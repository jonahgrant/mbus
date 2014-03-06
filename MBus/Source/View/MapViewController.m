//
//  MapViewController.m
//  MBus
//
//  Created by Jonah Grant on 3/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

@import MapKit;

#import "MapViewController.h"
#import "MapViewControllerModel.h"
#import "Constants.h"
#import "Bus.h"
#import "DataStore.h"
#import "BusAnnotation.h"
#import "CircleAnnotationView.h"

@interface MapViewController ()

@property (nonatomic, strong, readwrite) MapViewControllerModel *model;
@property (nonatomic, strong, readwrite) IBOutlet MKMapView *mapView;

- (void)loadAnnotations;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [[MapViewControllerModel alloc] init];
    @weakify(self);
    self.model.dataUpdatedBlock = ^ {
        @strongify(self);
        [self loadAnnotations];
    };
    [self.model beginContinuousFetching];
    
    [self zoomToCampus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    BusAnnotation *_annotation = (BusAnnotation *)annotation;
    CircleAnnotationView *pin = [[CircleAnnotationView alloc] initWithAnnotation:_annotation
                                                                 reuseIdentifier:@"Pin"
                                                                           color:_annotation.color
                                                                    outlineColor:[UIColor whiteColor]];
    pin.canShowCallout = YES;
    
    return pin;
}

@end
