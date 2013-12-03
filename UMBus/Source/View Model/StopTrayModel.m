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
#import "TTTLocationFormatter.h"
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
        
        [RACObserve(self, closestBus) subscribeNext:^(Bus *bus) {
            CLLocation *busLocation = [[CLLocation alloc] initWithLatitude:[self.closestBus.latitude doubleValue] longitude:[self.closestBus.longitude doubleValue]];
            CLLocation *stop = [[CLLocation alloc] initWithLatitude:[_stopAnnotation.stop.latitude doubleValue] longitude:[_stopAnnotation.stop.longitude doubleValue]];
            
            TTTLocationFormatter *locationFormatter = [[TTTLocationFormatter alloc] init];
            [locationFormatter.numberFormatter setMaximumSignificantDigits:2];
            [locationFormatter setBearingStyle:TTTBearingAbbreviationWordStyle];
            [locationFormatter setUnitSystem:TTTImperialSystem];
            
            self.distanceToClosestBus = [locationFormatter stringFromDistanceFromLocation:stop toLocation:busLocation];
            
            [self fetchClosestBusETA];
        }];
    }
    return self;
}

- (void)reset {
    _timeToClosestBus = nil;
    _closestBus = nil;
}

- (void)fetchClosestBus {
    NSArray *buses = _stopAnnotation.stop.busesServicingStop;
    NSArray *sortedBuses = [buses sortedArrayUsingComparator: ^(id a, id b) {
        Bus *bus1 = (Bus *)a;
        Bus *bus2 = (Bus *)b;
        
        CLLocation *stop = [[CLLocation alloc] initWithLatitude:[_stopAnnotation.stop.latitude doubleValue] longitude:[_stopAnnotation.stop.longitude doubleValue]];
        CLLocation *bus1Location = [[CLLocation alloc] initWithLatitude:[bus1.latitude doubleValue] longitude:[bus1.longitude doubleValue]];
        CLLocation *bus2Location = [[CLLocation alloc] initWithLatitude:[bus2.latitude doubleValue] longitude:[bus2.longitude doubleValue]];
        
        CLLocationDistance dist_a = [bus1Location distanceFromLocation:stop];
        CLLocationDistance dist_b = [bus2Location distanceFromLocation:stop];
        
        if ( dist_a < dist_b ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( dist_a > dist_b) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    self.closestBus = sortedBuses.firstObject;
}

- (void)fetchClosestBusETA {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    CLLocation *busStopLocation = [[CLLocation alloc] initWithLatitude:_stopAnnotation.coordinate.latitude longitude:_stopAnnotation.coordinate.longitude];
    CLLocation *busLocation = [[CLLocation alloc] initWithLatitude:[self.closestBus.latitude doubleValue] longitude:[self.closestBus.longitude doubleValue]];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:busStopLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (placemarks) {
                           MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
                           request.source = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:busStopLocation.coordinate
                                                                                                       addressDictionary:nil]];
                           request.destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:busLocation.coordinate
                                                                                                            addressDictionary:nil]];
                           MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
                           [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
                               if (error) {
                                   self.timeToClosestBus = nil;
                               } else {
                                   NSInteger travelTime = (NSInteger)response.expectedTravelTime;
                                   NSInteger seconds = travelTime % 60;
                                   NSInteger minutes = (travelTime / 60) % 60;
                                  
                                   self.timeToClosestBus = [NSString stringWithFormat:@"%02li:%02i", (long)minutes, seconds];
                               }
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           }];
                       }
                   }];
}

@end
