//
//  RouteMapViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RouteMapViewController.h"
#import "RouteMapViewControllerModel.h"
#import "TraceRoute.h"
#import "Arrival.h"
#import "HexColor.h"
#import "StopAnnotation.h"
#import "BusAnnotation.h"
#import "SVPulsingAnnotationView.h"
#import "StreetViewController.h"
#import "StopTray.h"
#import "StopTrayModel.h"
#import "Constants.h"

@interface RouteMapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *polyline;
@property (strong, nonatomic) StopTray *stopTray;

@end

@implementation RouteMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [[RouteMapViewControllerModel alloc] initWithArrival:self.arrival];
    [self.model fetchTraceRoute];
    [self.model fetchStopAnnotations];
    
    self.stopTray = [[StopTray alloc] initWithTintColor:[UIColor colorWithHexString:self.model.arrival.busRouteColor]];
    self.stopTray.frame = CGRectMake(0, self.view.frame.size.height + 44, self.stopTray.frame.size.width, self.stopTray.frame.size.height);
    self.stopTray.target = self;
    [self.view insertSubview:self.stopTray aboveSubview:self.mapView];

    self.title = self.model.arrival.name;
    
    [[RACObserve(self.model, polyline) filter:^BOOL(MKPolyline *polyline) {
        return (polyline) ? YES : NO;
    }] subscribeNext:^(MKPolyline *polyline) {
        [self.mapView addOverlay:polyline];
    }];

    [[RACObserve(self.model, stopAnnotations) filter:^BOOL(NSDictionary *annotations) {
        return (annotations.count > 0);
    }] subscribeNext:^(NSDictionary *annotations) {
        for (id key in annotations) {
            [self.mapView addAnnotation:(StopAnnotation *)[annotations objectForKey:key]];
        }
    }];
    
    [[RACObserve(self.model, busAnnotations) filter:^BOOL(NSDictionary *annotations) {
        return (annotations.count > 0);
    }] subscribeNext:^(NSDictionary *annotations) {
        for (id key in annotations) {
            [self.mapView addAnnotation:(BusAnnotation *)[annotations objectForKey:key]];
        }
    }];
    
    [self zoom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setInterfaceWithColor:[UIColor colorWithHexString:self.arrival.busRouteColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.model beginFetchingBuses];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.model endFetchingBuses];
}

#pragma Map

- (void)zoom {
    if (self.polyline) {
        [self zoomToFitPolyline];
    } else if (self.mapView.annotations.count >= 1) {
        [self zoomToFitAnnotations];
    } else {
        [self zoomToCampus];
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

- (void)zoomToCampus {
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(42.282707, -83.740196);
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    region.span = span;
    
    [_mapView setRegion:region animated:YES];
}

- (void)displayStreetViewForAnnotation:(NSObject<MKAnnotation> *)annotation {
    StreetViewController *streetViewController = [[StreetViewController alloc] initWithCoordinate:annotation.coordinate heading:0 title:annotation.title];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:streetViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)displayTray {
    SendEvent(ANALYTICS_DISPLAY_STOP_ANNOTATION_TRAY);
    
    [UIView animateWithDuration:0.5
                     animations:^ {
                         self.stopTray.frame = CGRectMake(
                                                          0,
                                                          self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.stopTray.frame.size.height,
                                                          self.stopTray.frame.size.width,
                                                          self.stopTray.frame.size.height
                                                          );
                     }];
}

- (void)dismissTray {
    SendEvent(ANALYTICS_HIDE_STOP_ANNOTATION_TRAY);
    
    [UIView animateWithDuration:0.5
                     animations:^ {
                         self.stopTray.frame = CGRectMake(
                                                          0,
                                                          self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height + self.stopTray.frame.size.height,
                                                          self.stopTray.frame.size.width,
                                                          self.stopTray.frame.size.height
                                                          );
                     } completion:NULL];
}

- (void)detailInformationForStopAnnotation:(StopAnnotation *)annotation {
    [self displayTray];
}

#pragma MKMapView

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithHexString:self.model.arrival.busRouteColor];
    renderer.lineWidth = 6.0;
    renderer.alpha = 0.8;
    
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    if ([annotation class] == [BusAnnotation class]) {
        SVPulsingAnnotationView *pin = [[SVPulsingAnnotationView alloc] initWithAnnotation:(BusAnnotation *)annotation
                                                                           reuseIdentifier:@"BusPin"];
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
    SendEvent(ANALYTICS_SELECT_STOP_ANNOTATION);
    
    NSObject<MKAnnotation> *annotation = view.annotation;
    if ([annotation class] == [StopAnnotation class]) {
        StopAnnotation *stopAnnotation = (StopAnnotation *)annotation;
        self.stopTray.model.stopAnnotation = stopAnnotation;
        [self detailInformationForStopAnnotation:stopAnnotation];
    }
}

@end
