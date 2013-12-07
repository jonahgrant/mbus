//
//  RouteMapViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RouteMapViewController.h"
#import "RouteMapViewControllerModel.h"
#import "TraceRoute.h"
#import "Arrival.h"
#import "HexColor.h"

@interface RouteMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *polyline;

@end

@implementation RouteMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [[RouteMapViewControllerModel alloc] initWithArrival:self.arrival];
    [self.model fetchTraceRoute];
    
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
}

- (void)drawRouteWithLocations:(NSArray *)locations {
    CLLocationCoordinate2D coordinates[locations.count];
    
    for (int i = 0; i < locations.count; i++) {
        CLLocation *location = locations[i];
        coordinates[i] = location.coordinate;
    }
    
    self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:locations.count];
    [self.mapView addOverlay:self.polyline];
    [self zoomToPolyLineInMapView:self.mapView polyLine:self.polyline animated:NO];
}

- (void)zoomToPolyLineInMapView:(MKMapView *)map polyLine:(MKPolyline *)polyLine animated:(BOOL)animated {
    MKPolygon *polygon = [MKPolygon polygonWithPoints:polyLine.points count:polyLine.pointCount];
    
    [self.mapView setRegion:MKCoordinateRegionForMapRect([polygon boundingMapRect]) animated:animated];
}

#pragma MKMapView

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithHexString:self.model.arrival.busRouteColor];
    polylineView.lineWidth = 5.0;
    
    return polylineView;
}

@end
