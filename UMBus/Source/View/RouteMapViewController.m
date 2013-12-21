//
//  RouteMapViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RouteMapViewController.h"
#import "RouteMapViewControllerModel.h"
#import "TraceRoute.h"
#import "Arrival.h"
#import "HexColor.h"
#import "StopAnnotation.h"

@interface RouteMapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *polyline;

@end

@implementation RouteMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [[RouteMapViewControllerModel alloc] initWithArrival:self.arrival];
    [self.model fetchTraceRoute];
    [self.model fetchStopAnnotations];
    
    [RACObserve(self.model, polyline) subscribeNext:^(MKPolyline *polyline) {
        if (polyline)
            [self.mapView addOverlay:polyline];
    }];

    [RACObserve(self.model, stopAnnotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            for (id key in annotations)
                [self.mapView addAnnotation:(StopAnnotation *)[annotations objectForKey:key]];
        }
    }];
    
    [self zoom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithHexString:self.arrival.busRouteColor]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self purgeMapMemory];
}

- (void)purgeMapMemory {
    self.mapView.mapType = MKMapTypeStandard;
    [self.mapView removeFromSuperview];
    self.mapView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma Map

- (void)drawPolylineWithLocations:(NSArray *)locations {
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

#pragma MKMapView

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithHexString:self.model.arrival.busRouteColor];
    renderer.lineWidth = 6.0;
    renderer.alpha = 0.8;
    
    return renderer;
}

@end
