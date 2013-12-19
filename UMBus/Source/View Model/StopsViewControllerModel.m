//
//  StopsViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/18/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopsViewControllerModel.h"
#import "LocationManager.h"
#import "DataStore.h"
#import "Stop.h"

@implementation StopsViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        if ([[DataStore sharedManager] persistedStops] && [[DataStore sharedManager] persistedLastKnownLocation]) {
            self.stops = [self sortedStopsByDistanceWithArray:[[DataStore sharedManager] persistedStops]];
        } else if ([[DataStore sharedManager] persistedStops] && ![[DataStore sharedManager] persistedLastKnownLocation]) {
            self.stops = [[DataStore sharedManager] persistedStops];
        } else {
            self.stops = [NSArray array];
        }

        [RACObserve([DataStore sharedManager], stops) subscribeNext:^(NSArray *stops) {
            if (stops && [DataStore sharedManager].lastKnownLocation) {
                self.stops = [self sortedStopsByDistanceWithArray:stops];
            } else {
                self.stops = stops;
            }
        }];
        
        [RACObserve([DataStore sharedManager], lastKnownLocation) subscribeNext:^(CLLocation *location) {
            if (location && [DataStore sharedManager].stops) {
                self.stops = [self sortedStopsByDistanceWithArray:[DataStore sharedManager].stops];
            }
        }];
    }
    return self;
}

- (NSArray *)sortedStopsByDistanceWithArray:(NSArray *)array {
    return [array sortedArrayUsingComparator:^(id a,id b) {
        Stop *stopA = a;
        Stop *stopB = b;
        
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:[stopA.latitude doubleValue] longitude:[stopA.longitude doubleValue]];
        CLLocation *bLocation = [[CLLocation alloc] initWithLatitude:[stopB.latitude doubleValue] longitude:[stopB.longitude doubleValue]];
        
        CLLocationDistance distanceA = [aLocation distanceFromLocation:[DataStore sharedManager].lastKnownLocation];
        CLLocationDistance distanceB = [bLocation distanceFromLocation:[DataStore sharedManager].lastKnownLocation];
                
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
    [[DataStore sharedManager] fetchStopsWithErrorBlock:^(NSError *error) {
        self.stops = self.stops;
    }];
}

@end
