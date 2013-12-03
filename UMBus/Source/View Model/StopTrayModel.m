//
//  StopTrayModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "StopTrayModel.h"
#import "StopAnnotation.h"
#import "UMNetworkingSession.h"
#import "Route.h"
#import "Stop.h"
#import "Bus.h"

@interface StopTrayModel ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;

@end

@implementation StopTrayModel

- (instancetype)init {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
    }
    return self;
}

- (void)fetchETA {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:_stopAnnotation.coordinate.latitude longitude:_stopAnnotation.coordinate.longitude];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:destinationLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (placemarks) {
                           MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
                           request.source = [MKMapItem mapItemForCurrentLocation];
                           request.destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destinationLocation.coordinate
                                                                                                            addressDictionary:nil]];
                           MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
                           [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
                               if (error) {
                                   NSLog(@"Error calculating ETA: %@", error.localizedDescription);
                               } else {
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
                                   
                                   _eta = timeToDestination;
                               }
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           }];
                       }
                   }];
}

@end
