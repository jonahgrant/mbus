//
//  MapViewController.m
//  MBus
//
//  Created by Jonah Grant on 3/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

@import MapKit;

#import "UMNetworkingSession.h"
#import "MapViewController.h"
#import "MapViewControllerModel.h"
#import "Constants.h"
#import "Bus.h"
#import "Arrival.h"
#import "ArrivalStop.h"
#import "TraceRoute.h"
#import "DataStore.h"
#import "BusAnnotation.h"
#import "CircleAnnotationView.h"
#import "RouteMapView.h"
#import "HexColor.h"

static int const TAB_BAR_HEIGHT = 49;
static int const ROUTE_SCROLL_VIEW_HEIGHT = 80;

@interface MapViewController () <UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UMNetworkingSession *networkingSession;
@property (nonatomic, strong, readwrite) MapViewControllerModel *model;
@property (nonatomic, strong, readwrite) IBOutlet MKMapView *mapView;
@property (nonatomic, strong, readwrite) UIScrollView *routeScrollView;
@property (nonatomic, strong, readwrite) Arrival *activeArrival;
@property (nonatomic, strong, readwrite) NSArray *activeArrivalAnnotations;

- (void)loadAnnotations;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.networkingSession = [[UMNetworkingSession alloc] init];

    self.model = [[MapViewControllerModel alloc] init];
    @weakify(self);
    self.model.dataUpdatedBlock = ^ {
        @strongify(self);
        [self loadAnnotations];
    };
    
    if (self.startCoordinate.latitude != 0 && self.startCoordinate.longitude != 0) {
        [self dropAndZoomToPinWithCoordinate:self.startCoordinate];
    } else {
        [self zoomToCampus];
        [self setupScrollView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.model beginContinuousFetching];
    [self resetInterface];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.model endContinuousFetching];
}

- (void)loadAnnotations {
    NSMutableArray *annotationArray = [NSMutableArray array];
    for (Bus *bus in [DataStore sharedManager].buses) {
        BusAnnotation *annotation = [self.model.busAnnotations objectForKey:bus.id];
        [self.mapView addAnnotation:annotation];
        [annotationArray addObject:annotation];
    }
    
    // remove buses no longer in service
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:self.mapView.annotations];
    
    for (int i = 0, j = (int)self.mapView.annotations.count; i < j; i++) {
        if ([intermediate[i] isKindOfClass:[MKPointAnnotation class]]) {
            [intermediate removeObject:intermediate[i]];
            break;
        }
    }
    
    [intermediate removeObjectsInArray:annotationArray];
    [self.mapView removeAnnotations:intermediate];
}

- (void)zoomToCampus {
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(CAMPUS_CENTER_LAT, CAMPUS_CENTER_LNG);
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
}

- (void)dropAndZoomToPinWithCoordinate:(CLLocationCoordinate2D)coordinate {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [_mapView addAnnotation:annotation];
    
    MKMapCamera *camera = [MKMapCamera new];
    camera.centerCoordinate = coordinate;
    camera.heading = 0;
    camera.pitch = 0;
    camera.altitude = 5000;
    [self.mapView setCamera:camera animated:NO];
}

#pragma mark UIScrollView

- (void)setupScrollView {
    CGRect scrollViewFrame = CGRectMake(0,
                                        CGRectGetHeight(self.view.frame) - ROUTE_SCROLL_VIEW_HEIGHT - TAB_BAR_HEIGHT,
                                        CGRectGetWidth([[UIApplication sharedApplication] keyWindow].frame),
                                        ROUTE_SCROLL_VIEW_HEIGHT);
    self.routeScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    self.routeScrollView.pagingEnabled = YES;
    self.routeScrollView.backgroundColor = [UIColor whiteColor];
    self.routeScrollView.showsHorizontalScrollIndicator = NO;
    self.routeScrollView.delegate = self;
    [self.view addSubview:self.routeScrollView];
    
    [[RACObserve([DataStore sharedManager], arrivals) filter:^BOOL(NSArray *arrivals) {
        return (arrivals.count > 0);
    }] subscribeNext:^(id x) {
        [self updateScrollView];
    }];
    
    RouteMapView *initialView = [[RouteMapView alloc] initWithTitle:@"Routes"
                                                           subtitle:@"Swipe left to choose a route"
                                                    backgroundColor:[UIColor whiteColor]
                                                          textColor:[UIColor blackColor]
                                                              frame:CGRectMake(0, 0, CGRectGetWidth(scrollViewFrame), ROUTE_SCROLL_VIEW_HEIGHT)];
    [self.routeScrollView addSubview:initialView];
}

- (void)updateScrollView {
    self.routeScrollView.contentSize = CGSizeMake(([DataStore sharedManager].arrivals.count + 1) * CGRectGetWidth([[UIApplication sharedApplication] keyWindow].frame) + 1,
                                                  ROUTE_SCROLL_VIEW_HEIGHT);
    
    for (int i = 0, j = (int)[DataStore sharedManager].arrivals.count; i < j; i++) {
        Arrival *arrival = [DataStore sharedManager].arrivals[i];
        RouteMapView *view = [[RouteMapView alloc] initWithTitle:arrival.name
                                                        subtitle:[NSString stringWithFormat:@"%lu stops", (unsigned long)arrival.stops.count]
                                                 backgroundColor:[UIColor colorWithHexString:arrival.busRouteColor]
                                                       textColor:[UIColor whiteColor]
                                                           frame:CGRectMake((i + 1) * CGRectGetWidth(self.routeScrollView.frame),
                                                                            0,
                                                                            CGRectGetWidth(self.routeScrollView.frame),
                                                                            CGRectGetHeight(self.routeScrollView.frame))];
        [self.routeScrollView addSubview:view];
    }
}

- (void)loadTraceRouteForArrivalID:(NSString *)arrivalID {
    [self.mapView removeOverlays:self.mapView.overlays];

    if ([[DataStore sharedManager] hasTraceRouteForRouteID:arrivalID]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPolyline *polyline = [self polylineFromTraceRoute:[[DataStore sharedManager] traceRouteForRouteID:arrivalID]];
            [self.mapView addOverlay:polyline];
            [self.mapView setVisibleMapRect:[polyline boundingMapRect]
                                edgePadding:UIEdgeInsetsMake(20, 20, 20, 20)
                                   animated:YES];
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.networkingSession fetchTraceRouteForRouteID:arrivalID
                                             withSuccessBlock:^(NSArray *traceRoute) {
                                                 if (traceRoute) {
                                                     MKPolyline *polyline = [self polylineFromTraceRoute:traceRoute];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self.mapView addOverlay:polyline];
                                                         [self.mapView setVisibleMapRect:[polyline boundingMapRect]
                                                                             edgePadding:UIEdgeInsetsMake(20, 20, 20, 20)
                                                                                animated:YES];
                                                     });
                                                     [[DataStore sharedManager] persistTraceRoute:traceRoute forRouteID:arrivalID];
                                                 } else {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self resetActiveArrival];
                                                     });
                                                 }
                                             } errorBlock:^(NSError *error) {
                                                 
                                             }];

        });
    }
    
    //[self loadAnnotationsForActiveArrival];
}

- (void)loadAnnotationsForActiveArrival {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0, j = (int)self.activeArrival.stops.count; i < j; i++) {
        ArrivalStop *arrivalStop = self.activeArrival.stops[i];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = arrivalStop.coordinate;
        annotation.title = arrivalStop.name2;
        annotation.subtitle = arrivalStop.name;
        [mutableArray addObject:annotation];
    }

    self.activeArrivalAnnotations = mutableArray;
    [self.mapView addAnnotations:self.activeArrivalAnnotations];
}

- (MKPolyline *)polylineFromTraceRoute:(NSArray *)traceRoute {
    CLLocationCoordinate2D coordinates[traceRoute.count];
    
    for (int i = 0, n = (int)traceRoute.count; i < n; i++) {
        TraceRoute *route = traceRoute[i];
        coordinates[i] = CLLocationCoordinate2DMake([route.latitude doubleValue], [route.longitude doubleValue]);
    }
    
    return [MKPolyline polylineWithCoordinates:coordinates count:traceRoute.count];
}


- (void)resetActiveArrival {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self zoomToCampus];
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:self.activeArrivalAnnotations];
    });
}

#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    NSInteger page = lround(scrollView.contentOffset.x / CGRectGetWidth([[UIApplication sharedApplication] keyWindow].frame));
   
    if (previousPage != page) {
        previousPage = page;
        
        if (page == 0) {
            [self resetActiveArrival];
        } else {
            self.activeArrival = [DataStore sharedManager].arrivals[page - 1];
            [self loadTraceRouteForArrivalID:self.activeArrival.id];
        }
    }
}

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"annotation_ID"];
        if (pin == nil) {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"annotation_ID"];
        } else {
            pin.annotation = annotation;
        }
        
        pin.pinColor = MKPinAnnotationColorRed;
        pin.animatesDrop = YES;
        
        return pin;
    } else if ([annotation isKindOfClass:[BusAnnotation class]]) {
        BusAnnotation *_annotation = (BusAnnotation *)annotation;
        CircleAnnotationView *pin = [[CircleAnnotationView alloc] initWithAnnotation:_annotation
                                                                     reuseIdentifier:@"Pin"
                                                                               color:_annotation.color
                                                                        outlineColor:[UIColor whiteColor]];
        pin.canShowCallout = YES;
        
        return pin;
    }
    
    return nil;
}

#pragma MKMapView

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithHexString:self.activeArrival.busRouteColor];
    renderer.lineWidth = 6.0;
    renderer.alpha = 0.8;
    
    return renderer;
}

@end
