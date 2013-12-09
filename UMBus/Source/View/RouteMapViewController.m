//
//  RouteMapViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RouteMapViewController.h"
#import "RouteMapViewControllerModel.h"
#import "TraceRoute.h"
#import "Arrival.h"
#import "ArrivalStop.h"
#import "HexColor.h"
#import "Bus.h"
#import "BusAnnotation.h"
#import "StopAnnotation.h"
#import "CircleAnnotationView.h"
#import "SVPulsingAnnotationView.h"
#import "StopTray.h"
#import "StopTrayModel.h"
#import "StreetViewController.h"

@interface RouteMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *polyline;
@property (strong, nonatomic) BusAnnotation *busAnnotation;
@property (strong, nonatomic) StopTray *stopTray;

@end

@implementation RouteMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[RouteMapViewControllerModel alloc] initWithArrival:self.arrival];
    [self.model fetchTraceRoute];
    [self.model beginBusFetching];
    
    self.title = @"Route";
    
    _stopTray = [[StopTray alloc] initWithTintColor:[UIColor colorWithHexString:self.model.arrival.busRouteColor]];
    _stopTray.frame = CGRectMake(0, self.view.frame.size.height + 44, _stopTray.frame.size.width, _stopTray.frame.size.height);
    _stopTray.target = self;
    [self.view insertSubview:_stopTray aboveSubview:self.mapView];
    
    [RACObserve(self.model, traceRoutes) subscribeNext:^(NSArray *traceRoute) {
        if (traceRoute) {
            NSMutableArray *locations = [NSMutableArray array];
            for (TraceRoute *route in self.model.traceRoutes) {
                CLLocation *location = [[CLLocation alloc] initWithLatitude:[route.latitude doubleValue] longitude:[route.longitude doubleValue]];
                [locations addObject:location];
            }
            [self drawRouteWithLocations:locations];
        }
    }];
    
    [RACObserve(self.model, busAnnotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            for (id key in annotations) {
                [self.mapView addAnnotation:(BusAnnotation *)[annotations objectForKey:key]];
            }
        }
    }];
    
    [RACObserve(self.model, stopAnnotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            for (id key in annotations) {
                [self.mapView addAnnotation:(StopAnnotation *)[annotations objectForKey:key]];
            }
        }
    }];
    
    [self zoom];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.model beginBusFetching];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.model endBusFetching];
}

- (void)drawRouteWithLocations:(NSArray *)locations {
    CLLocationCoordinate2D coordinates[locations.count];
    
    for (int i = 0; i < locations.count; i++) {
        CLLocation *location = locations[i];
        coordinates[i] = location.coordinate;
    }
    
    self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:locations.count];
    [self.mapView addOverlay:self.polyline];
    [self zoom];
}

- (void)zoom {
    if (self.polyline) {
        [self zoomToFitPolyline];
    } else {
        [self zoomToFitAnnotations];
    }
}

- (void)zoomToFitPolyline {
    MKPolygon *polygon = [MKPolygon polygonWithPoints:self.polyline.points count:self.polyline.pointCount];
    
    [self.mapView setRegion:MKCoordinateRegionForMapRect([polygon boundingMapRect]) animated:NO];
}

- (void)zoomToFitAnnotations {
    MKMapRect zoomRect = MKMapRectNull;
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 10, 10);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
    }
    [self.mapView setVisibleMapRect:zoomRect animated:NO];
}

- (void)displayStreetViewForAnnotation:(NSObject<MKAnnotation> *)annotation {
    StreetViewController *streetViewController = [[StreetViewController alloc] initWithAnnotation:annotation];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:streetViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)displayTray {
    [UIView animateWithDuration:0.5
                     animations:^ {
                         _stopTray.frame = CGRectMake(0,
                                                      self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - _stopTray.frame.size.height,
                                                      _stopTray.frame.size.width,
                                                      _stopTray.frame.size.height);
                     }];
}

- (void)dismissTray {
    [UIView animateWithDuration:0.5
                     animations:^ {
                         _stopTray.frame = CGRectMake(0,
                                                      self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height + _stopTray.frame.size.height,
                                                      _stopTray.frame.size.width,
                                                      _stopTray.frame.size.height);
                     } completion:NULL];
}

- (void)displayDirections {
    // open Maps.app
}

- (void)detailInformationForStopAnnotation:(StopAnnotation *)annotation {
    [self displayTray];
}

- (void)detailInformationForBusAnnotation:(BusAnnotation *)annotation {
    // no detailing info for bus for now
}

#pragma MKMapView

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithHexString:self.model.arrival.busRouteColor];
    polylineView.lineWidth = 10.0;
    polylineView.alpha = 0.8;
    
    return polylineView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    if ([annotation class] == [BusAnnotation class]) {
        SVPulsingAnnotationView *pin = [[SVPulsingAnnotationView alloc] initWithAnnotation:(BusAnnotation *)annotation reuseIdentifier:@"BusPin"];
        pin.annotationColor = [UIColor colorWithHexString:self.model.arrival.busRouteColor];
        
        return pin;
    } else if ([annotation class] == [StopAnnotation class] ) {
        MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:(StopAnnotation *)annotation
                                                                       reuseIdentifier:@"Stop"];
        pinView.canShowCallout = YES;
        pinView.pinColor = MKPinAnnotationColorRed;
        
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self dismissTray];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSObject<MKAnnotation> *annotation = view.annotation;
    if ([annotation class] == [BusAnnotation class]) {
        BusAnnotation *busAnnotation = (BusAnnotation *)annotation;
        [self detailInformationForBusAnnotation:busAnnotation];
    } else if ([annotation class] == [StopAnnotation class]){
        StopAnnotation *stopAnnotation = (StopAnnotation *)annotation;
        _stopTray.model.stopAnnotation = stopAnnotation;
        [self detailInformationForStopAnnotation:stopAnnotation];
    }
}

@end
