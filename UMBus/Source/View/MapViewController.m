//
//  MapViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "MapViewControllerModel.h"
#import "Bus.h"
#import "BusAnnotation.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"University of Michigan";
    
    [self zoomToCampus];
    
    self.model = [[MapViewControllerModel alloc] init];
    self.model.continuouslyUpdate = YES;
    [self.model fetchBuses];
    
    [RACObserve(self, model.annotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            for (Bus *bus in self.model.buses) {
                BusAnnotation *annotation = [annotations objectForKey:bus.id];
                [self.mapView addAnnotation:annotation];
            }
        }
    }];
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

@end
