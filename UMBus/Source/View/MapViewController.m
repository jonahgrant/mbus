//
//  MapViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/8/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "MapViewControllerModel.h"
#import "Bus.h"
#import "BusAnnotation.h"
#import "CircleAnnotationView.h"
#import "HexColor.h"
#import "Arrival.h"
#import "DataStore.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"University of Michigan";

    [self.tabBarController.tabBar setTranslucent:YES];
    
    self.model = [[MapViewControllerModel alloc] init];
    [self.model beginFetchingBuses];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.model action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [RACObserve(self, model.busAnnotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            NSMutableArray *annotationArray = [NSMutableArray array];
            for (Bus *bus in self.model.buses) {
                BusAnnotation *annotation = [annotations objectForKey:bus.id];
                [self.mapView addAnnotation:annotation];
                [annotationArray addObject:annotation];
            }
           
            // Remove buses no longer running
            NSMutableArray *intermediate = [NSMutableArray arrayWithArray:self.mapView.annotations];
            [intermediate removeObjectsInArray:annotationArray];
            [self.mapView removeAnnotations:intermediate];
        }
    }];
    
    [RACObserve(self.model, fetchBusesError) subscribeNext:^(NSError *error) {
        // error fetching buses
    }];
    
    [self zoomToCampus];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.model beginFetchingBuses];
    [self.navigationController.navigationBar setTintColor:nil];
    [self.tabBarController.tabBar setTintColor:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.model endFetchingBuses];
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

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // don't change the view for the pin that represents user's current location
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    BusAnnotation *_annotation = (BusAnnotation *)annotation;
    
    CircleAnnotationView *pin = [[CircleAnnotationView alloc] initWithAnnotation:_annotation
                                                                 reuseIdentifier:@"Pin"
                                                                           color:_annotation.color
                                                                    outlineColor:[UIColor whiteColor]];
    pin.canShowCallout = YES;
    
    return pin;
}


@end
