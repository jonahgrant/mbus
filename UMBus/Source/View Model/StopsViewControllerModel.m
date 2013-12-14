//
//  StopsViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "StopsViewControllerModel.h"
#import "DataStore.h"
#import "Stop.h"
#import "LocationManager.h"

@implementation StopsViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        [[LocationManager sharedManager] startFetchingLocation];

        [RACObserve([DataStore sharedManager], stops) subscribeNext:^(NSArray *stops) {
            if (stops && [[LocationManager sharedManager] currentLocation]) {
                self.sortedStops = [self stopsOrderedByTimeOfArrivalWithStops:stops];
            } else {
                self.sortedStops = stops;
            }
        }];
        
        [RACObserve([LocationManager sharedManager], currentLocation) subscribeNext:^(CLLocation *location) {
            if (location && [DataStore sharedManager].stops) {
                self.sortedStops = [self stopsOrderedByTimeOfArrivalWithStops:[DataStore sharedManager].stops];
            }
        }];
    }
    return self;
}

- (NSArray *)stopsOrderedByTimeOfArrivalWithStops:(NSArray *)stops {
    return [stops sortedArrayUsingComparator:^(id a,id b) {
        Stop *stopA = a;
        Stop *stopB = b;

        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:[stopA.latitude doubleValue] longitude:[stopA.longitude doubleValue]];
        CLLocation *bLocation = [[CLLocation alloc] initWithLatitude:[stopB.latitude doubleValue] longitude:[stopB.longitude doubleValue]];
        
        CLLocationDistance distanceA = [aLocation distanceFromLocation:[[LocationManager sharedManager] currentLocation]];
        CLLocationDistance distanceB = [bLocation distanceFromLocation:[[LocationManager sharedManager] currentLocation]];
        
        if (distanceA < distanceB) {
            return NSOrderedAscending;
        } else if (distanceA > distanceB) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
}

- (void)fetchStops {
    [[DataStore sharedManager] fetchStopsWithErrorBlock:NULL];
}

@end
