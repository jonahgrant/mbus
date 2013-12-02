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

/*- (void)updateImageForAnnotation:(BusAnnotation *)annotation {
    MKAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
    [annotationView setImage:[self busImageForHeading:annotation.heading]];
}

- (UIImage *)busImageForHeading:(CGFloat)heading {
    int intHeading = floorf(heading);
    
    if (45 > intHeading && intHeading >= 0) {
        return [UIImage imageNamed:@"bus0"];
    } else if (90 > intHeading && intHeading >= 45) {
        return [UIImage imageNamed:@"bus45"];
    } else if (135 > intHeading && intHeading >= 90) {
        return [UIImage imageNamed:@"bus90"];
    } else if (180 > intHeading && intHeading >= 135) {
        return [UIImage imageNamed:@"bus135"];
    } else if (225 > intHeading && intHeading >= 180) {
        return [UIImage imageNamed:@"bus180"];
    } else if (270 > intHeading && intHeading >= 225) {
        return [UIImage imageNamed:@"bus225"];
    } else if (315 > intHeading && intHeading >= 270) {
        return [UIImage imageNamed:@"bus270"];
    } else if (360 > intHeading && intHeading >= 315) {
        return [UIImage imageNamed:@"bus315"];
    }
    
    return [UIImage imageNamed:@"bus0"];
}*/

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // don't change the view for the pin that represents user's current location
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;

    BusAnnotation *busAnnotation = (BusAnnotation *)annotation;

    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:busAnnotation reuseIdentifier:@"Identifier"];
    pinView.canShowCallout = YES;
    
    if ([annotation class] == [BusAnnotation class]) {
        pinView.pinColor = MKPinAnnotationColorRed;
    } else if ([annotation class] == [StopAnnotation class]) {
        pinView.pinColor = MKPinAnnotationColorGreen;
    }
    
    //pinView.image = [self busImageForHeading:busAnnotation.heading];
    
    return pinView;
}

@end
