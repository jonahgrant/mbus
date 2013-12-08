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
#import "StopAnnotation.h"
#import "CircleAnnotationView.h"
#import "SVPulsingAnnotationView.h"

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
    [self.model beginBusFetching];
    
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

#pragma MKMapView

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithHexString:self.model.arrival.busRouteColor];
    polylineView.lineWidth = 10.0;
    
    return polylineView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    UIColor *routeColor = [UIColor colorWithHexString:self.model.arrival.busRouteColor];
    if ([annotation class] == [BusAnnotation class]) {
        SVPulsingAnnotationView *pin = [[SVPulsingAnnotationView alloc] initWithAnnotation:(BusAnnotation *)annotation reuseIdentifier:@"BusPin"];
        pin.annotationColor = [UIColor colorWithRed:(1-CGColorGetComponents(routeColor.CGColor)[0])
                                              green:(1-CGColorGetComponents(routeColor.CGColor)[1])
                                               blue:(1-CGColorGetComponents(routeColor.CGColor)[2])
                                              alpha:CGColorGetAlpha(routeColor.CGColor)];
        
        return pin;
    } else if ([annotation class] == [StopAnnotation class] ) {
        CircleAnnotationView *pin = [[CircleAnnotationView alloc] initWithAnnotation:(StopAnnotation *)annotation
                                                                         reuseIdentifier:@"Pin"
                                                                                   color:routeColor
                                                                            outlineColor:[UIColor whiteColor]];
        pin.canShowCallout = YES;
        return pin;
    }
    
    return nil;
}

@end
