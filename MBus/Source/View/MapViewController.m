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
    
    if (self.startCoordinate.latitude != 0 && self.startCoordinate.longitude != 0) {
        [self dropAndZoomToPinWithCoordinate:self.startCoordinate];
    } else {
        [self zoomToCampus];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.model beginContinuousFetching];
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
    
    for (int i = 0, j = self.mapView.annotations.count; i < j; i++) {
        if ([intermediate[i] isKindOfClass:[MKPointAnnotation class]]) {
            [intermediate removeObject:intermediate[i]];
            break;
        }
    }
    
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

- (void)dropAndZoomToPinWithCoordinate:(CLLocationCoordinate2D)coordinate {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [_mapView addAnnotation:annotation];
    
    MKMapCamera *camera = [MKMapCamera new];
    camera.centerCoordinate = coordinate;
    camera.heading = 0;
    camera.pitch = 0;
    camera.altitude = 5000;
    [self.mapView setCamera:camera animated:NO];
}

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"annotation_ID"];
        if (pin == nil) {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"annotation_ID"];
        } else {
            pin.annotation = annotation;
        }
        
        pin.pinColor = MKPinAnnotationColorRed;
        pin.animatesDrop = YES;
        
        return pin;
    } else if ([annotation isKindOfClass:[BusAnnotation class]]) {
        BusAnnotation *_annotation = (BusAnnotation *)annotation;
        CircleAnnotationView *pin = [[CircleAnnotationView alloc] initWithAnnotation:_annotation
                                                                     reuseIdentifier:@"Pin"
                                                                               color:_annotation.color
                                                                        outlineColor:[UIColor whiteColor]];
        pin.canShowCallout = YES;
        
        return pin;
    }
    
    return nil;
}

@end
