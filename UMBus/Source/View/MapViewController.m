//
//  MapViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "MapViewControllerModel.h"
#import "BusAnnotation.h"
#import "CircleAnnotationView.h"
#import "Bus.h"
#import "Constants.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[MapViewControllerModel alloc] init];
    [self.model beginContinuousFetching];
    self.title = kMap;
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self.model
                                                                                   action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [self zoomToCampus];
    
    [RACObserve(self, model.busAnnotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            NSMutableArray *annotationArray = [NSMutableArray array];
            for (Bus *bus in self.model.buses) {
                BusAnnotation *annotation = [annotations objectForKey:bus.id];
                [self.mapView addAnnotation:annotation];
                [annotationArray addObject:annotation];
            }
            
            // Remove buses no longer in service
            NSMutableArray *intermediate = [NSMutableArray arrayWithArray:self.mapView.annotations];
            [intermediate removeObjectsInArray:annotationArray];
            [self.mapView removeAnnotations:intermediate];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setTintColor:nil];
    [self.tabBarController.tabBar setTintColor:nil];
    [self.model beginContinuousFetching];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.model endContinuousFetching];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    BusAnnotation *_annotation = (BusAnnotation *)annotation;
    
    CircleAnnotationView *pin = [[CircleAnnotationView alloc] initWithAnnotation:_annotation
                                                                 reuseIdentifier:@"Pin"
                                                                           color:_annotation.color
                                                                    outlineColor:[UIColor whiteColor]];
    pin.canShowCallout = YES;
    
    return pin;
}

@end
