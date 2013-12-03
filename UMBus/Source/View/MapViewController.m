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
#import "HMRectBackgroundLabel.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolTray;
@property (strong, nonatomic) HMRectBackgroundLabel *label;

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
    
    [self.model.streetViewBarButtonItem setAction:@selector(displayStreetView)];
    [self.model.directionsBarButtonItem setAction:@selector(displayDirections)];

    _label = [[HMRectBackgroundLabel alloc] initWithFrame:CGRectMake(5, 0, 100, 34)];
    _label.backgroundColor = [UIColor colorWithRed:0.904637 green:0.904637 blue:0.904637 alpha:1.0000];
    
    [self.toolTray setItems:@[self.model.streetViewBarButtonItem,
                              self.model.directionsBarButtonItem,
                              [[UIBarButtonItem alloc] initWithCustomView:_label]]];
    
    self.toolTray.frame = CGRectMake(0, self.view.frame.size.height + 44, self.view.frame.size.width, 44);
    [self.view insertSubview:self.toolTray aboveSubview:self.mapView];
    
    [RACObserve(self, model.busAnnotations) subscribeNext:^(NSDictionary *annotations) {
        if (annotations) {
            for (Bus *bus in self.model.buses) {
                BusAnnotation *annotation = [annotations objectForKey:bus.id];
                [self.mapView addAnnotation:annotation];
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
    [UIView animateWithDuration:0.5
                     animations:^ {
                         self.toolTray.frame = CGRectMake(0,
                                                          self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.toolTray.frame.size.height,
                                                          self.toolTray.frame.size.width,
                                                          self.toolTray.frame.size.height);
                     } completion:NULL];
}

- (void)dismissTray {
    [UIView animateWithDuration:0.5
                     animations:^ {
                         self.toolTray.frame = CGRectMake(0,
                                                          self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height + self.toolTray.frame.size.height,
                                                          self.toolTray.frame.size.width,
                                                          self.toolTray.frame.size.height);
                     } completion:NULL];
}

- (void)displayStreetView {
    StreetViewController *streetViewController = [[StreetViewController alloc] initWithAnnotation:self.mapView.selectedAnnotations.firstObject];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:streetViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)displayDirections {

}

- (void)fetchETA {
    NSObject<MKAnnotation> *annotation = self.mapView.selectedAnnotations.firstObject;
    CLLocation *destinationLocation;
    if ([annotation class] == [BusAnnotation class]) {
        BusAnnotation *busAnnotation = (BusAnnotation *)annotation;
        destinationLocation = [[CLLocation alloc] initWithLatitude:busAnnotation.coordinate.latitude longitude:busAnnotation.coordinate.longitude];
    } else if ([annotation class] == [StopAnnotation class]){
        StopAnnotation *stopAnnotation = (StopAnnotation *)annotation;
        destinationLocation = [[CLLocation alloc] initWithLatitude:stopAnnotation.coordinate.latitude longitude:stopAnnotation.coordinate.longitude];
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:destinationLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (placemarks) {
                           MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
                           request.source = [MKMapItem mapItemForCurrentLocation];
                           
                           MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:destinationLocation.coordinate addressDictionary:nil];
                           request.destination = [[MKMapItem alloc] initWithPlacemark:placemark];
                           
                           MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
                           [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
                               NSInteger travelTime = (NSInteger)response.expectedTravelTime;
                               NSInteger seconds = travelTime % 60;
                               NSInteger minutes = (travelTime / 60) % 60;
                               NSInteger hours = (travelTime / 3600);
                               
                               NSString *timeToDestination;
                               if (hours > 0) {
                                   timeToDestination = [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
                               } else if (minutes > 0) {
                                   timeToDestination = [NSString stringWithFormat:@"%02i:%02i", minutes, seconds];
                               } else {
                                   timeToDestination = [NSString stringWithFormat:@"%02i", seconds];
                               }
                               
                               _label.text = [NSString stringWithFormat:@" %@ away", timeToDestination];
                               _label.frame = CGRectMake(_label.frame.origin.x,
                                                         _label.frame.origin.y,
                                                         [_label.text sizeWithAttributes:@{NSFontAttributeName: _label.font}].width + 10,
                                                         _label.frame.size.height);
                           }];
                       }
                   }];
}

- (void)detailInformationForStopAnnotation:(StopAnnotation *)annotation {
    [self displayTray];
    [self fetchETA];
}

- (void)detailInformationForBusAnnotation:(BusAnnotation *)annotation {
    // no detailing info for bus for now
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
    }
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self dismissTray];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSObject<MKAnnotation> *annotation = view.annotation;
    if ([annotation class] == [BusAnnotation class]) {
        BusAnnotation *busAnnotation = (BusAnnotation *)annotation;
        [self detailInformationForBusAnnotation:busAnnotation];
    } else if ([annotation class] == [StopAnnotation class]){
        StopAnnotation *stopAnnotation = (StopAnnotation *)annotation;
        [self detailInformationForStopAnnotation:stopAnnotation];
    }
}

@end
