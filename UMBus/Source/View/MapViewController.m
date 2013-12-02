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
#import "Stop.h"
#import "StopAnnotation.h"
#import "StreetViewController.h"

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
    [self.model fetchStops];
    
    [RACObserve(self, model.busAnnotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            for (Bus *bus in self.model.buses) {
                BusAnnotation *annotation = [annotations objectForKey:bus.id];
                [self.mapView addAnnotation:annotation];
                //[self updateImageForAnnotation:annotation];
            }
        }
    }];
    
    [RACObserve(self, model.stopAnnotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            for (Stop *stop in self.model.stops) {
                StopAnnotation *annotation = [annotations objectForKey:stop.id];
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

- (void)displayTray {
    
}

- (void)detailInformationForStopAnnotation:(StopAnnotation *)annotation {
    StreetViewController *streetViewController = [[StreetViewController alloc] initWithAnnotation:annotation];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:streetViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)detailInformationForBusAnnotation:(BusAnnotation *)annotation {
    NSLog(@"Detail bus info");
}

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // don't change the view for the pin that represents user's current location
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;

    BusAnnotation *busAnnotation = (BusAnnotation *)annotation;

    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:busAnnotation reuseIdentifier:[NSString stringWithFormat:@"%@", busAnnotation.id]];
    pinView.canShowCallout = YES;
    
    if ([annotation class] == [BusAnnotation class]) {
        pinView.pinColor = MKPinAnnotationColorRed;
    } else if ([annotation class] == [StopAnnotation class]) {
        pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSObject<MKAnnotation> *annotation = view.annotation;
    if ([annotation class] == [BusAnnotation class]) {
        BusAnnotation *busAnnotation = (BusAnnotation *)annotation;
        [self detailInformationForBusAnnotation:busAnnotation];
    } else if ([annotation class] == [StopAnnotation class]){
        StopAnnotation *stopAnnotation = (StopAnnotation *)annotation;
        [self detailInformationForStopAnnotation:stopAnnotation];
    }
}

/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSObject<MKAnnotation> *annotation = view.annotation;
    if ([annotation class] == [BusAnnotation class]) {
        BusAnnotation *busAnnotation = (BusAnnotation *)annotation;
        [self detailInformationForBusAnnotation:busAnnotation];
    } else if ([annotation class] == [StopAnnotation class]){
        StopAnnotation *stopAnnotation = (StopAnnotation *)annotation;
        //[self detailInformationForStopAnnotation:stopAnnotation];
    }
}*/


@end
