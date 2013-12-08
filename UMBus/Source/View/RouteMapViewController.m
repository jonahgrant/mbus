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
#import "ArrivalStop.h"
#import "HexColor.h"
#import "Bus.h"
#import "BusAnnotation.h"

@interface RouteMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *polyline;
@property (strong, nonatomic) BusAnnotation *busAnnotation;

@end

@implementation RouteMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[RouteMapViewControllerModel alloc] initWithArrival:self.arrival];
    [self.model fetchTraceRoute];
    [self.model fetchBus];
    
    self.busAnnotation = [[BusAnnotation alloc] init];
    [self.mapView addAnnotation:self.busAnnotation];

    self.title = @"Route";
    
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
    
    [RACObserve(self.model, arrival.stops) subscribeNext:^(NSArray *stops) {
        if (stops) {
            [self addStops];
        }
    }];
    
    [RACObserve(self.model, bus) subscribeNext:^(Bus *bus) {
        if (bus) {
            self.busAnnotation.bus = bus;
            [self.model fetchBus];
            NSLog(@"got bus");
        }
    }];
}

- (NSString *)arrivalSubtitleForTimeInterval:(NSTimeInterval)interval {
    int minutes = ((NSInteger)interval / 60) % 60;
    if (minutes == 00) {
        return @"Arriving now";
    }
    
    return [NSString stringWithFormat:@"Arriving in %02im", minutes];
}

- (void)addStops {
    for (ArrivalStop *stop in self.model.arrival.stops) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = stop.coordinate;
        annotation.title = stop.name2;
        annotation.subtitle = [self arrivalSubtitleForTimeInterval:stop.timeOfArrival];
        [self.mapView addAnnotation:annotation];
    }
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


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // don't change the view for the pin that represents user's current location
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    BusAnnotation *busAnnotation = (BusAnnotation *)annotation;
    
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:busAnnotation reuseIdentifier:@"Pin"];
    pinView.canShowCallout = YES;
    
    if ([annotation class] == [BusAnnotation class]) {
        pinView.pinColor = MKPinAnnotationColorRed;
    } else {
        pinView.pinColor = MKPinAnnotationColorGreen;
    }
    
    return pinView;
}

@end
