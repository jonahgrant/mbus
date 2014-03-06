//
//  StopsViewControllerModel.m
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "StopsViewControllerModel.h"
#import "DataStore.h"
#import "LocationManager.h"
#import "Stop.h"
#import "StopCellModel.h"
#import "Constants.h"

@interface StopsViewControllerModel ()

@property (nonatomic, strong, readwrite) NSArray *stops, *stopCellModels;
@property (nonatomic, copy, readwrite) NSString *sectionHeaderText;

@end

@implementation StopsViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        
        // handle persisted data when the app initially launches
        if ([[DataStore sharedManager] persistedStops] && [[DataStore sharedManager] persistedLastKnownLocation]) {
            self.stops = [self sortedStopsByDistanceWithArray:[[DataStore sharedManager] persistedStops]
                                                     location:[[DataStore sharedManager] persistedLastKnownLocation]];
        } else if ([[DataStore sharedManager] persistedStops] && ![[DataStore sharedManager] persistedLastKnownLocation]) {
            self.stops = [[DataStore sharedManager] persistedStops];
        } else {
            self.stops = [NSArray array];
        }
        
        [[RACObserve(self, stops) filter:^BOOL(NSArray *stops) {
            return (stops.count > 0);
        }] subscribeNext:^(NSArray *stops) {
            NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:stops.count];
            
            for (Stop *stop in stops) {
                StopCellModel *stopCellModel = [[StopCellModel alloc] initWithStop:stop];
                [mutableArray addObject:stopCellModel];
            }
            
            self.stopCellModels = mutableArray;
            
            self.sectionHeaderText = ([DataStore sharedManager].arrivals) ? NEARBY_STOPS_IN_SERVICE : NEARBY_STOPS;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataUpdatedBlock();
            });
        }];

        // handle incoming data
        [[RACObserve([DataStore sharedManager], stops) filter:^BOOL(NSArray *stops) {
            return (stops.count > 0);
        }] subscribeNext:^(NSArray *stops) {
            if (([DataStore sharedManager].lastKnownLocation || [[DataStore sharedManager] persistedLastKnownLocation]) && [DataStore sharedManager].arrivals) {
                self.stops = [self sortedStopsByDistanceWithArray:[[DataStore sharedManager] stopsBeingServicedInArray:stops]
                                                         location:([DataStore sharedManager].lastKnownLocation) ?
                                                                    [DataStore sharedManager].lastKnownLocation :
                                                                    [[DataStore sharedManager] persistedLastKnownLocation]];
            } else if ([DataStore sharedManager].arrivals && ![DataStore sharedManager].lastKnownLocation && ![[DataStore sharedManager] persistedLastKnownLocation]) {
                self.stops = [[DataStore sharedManager] stopsBeingServicedInArray:stops];
            } else if (([DataStore sharedManager].lastKnownLocation || [[DataStore sharedManager] persistedLastKnownLocation]) && ![DataStore sharedManager].arrivals) {
                self.stops = [self sortedStopsByDistanceWithArray:stops location:([DataStore sharedManager].lastKnownLocation) ? [DataStore sharedManager].lastKnownLocation : [[DataStore sharedManager] persistedLastKnownLocation]];
            } else if (stops) {
                self.stops = stops;
            }
        }];
        
        [[RACObserve([DataStore sharedManager], arrivals) filter:^BOOL(NSArray *arrivals) {
            return (arrivals.count > 0);
        }] subscribeNext:^(NSArray *arrivals) {
            if (([DataStore sharedManager].lastKnownLocation || [[DataStore sharedManager] persistedLastKnownLocation]) &&
                ([DataStore sharedManager].stops || [[DataStore sharedManager] persistedStops])) {
                self.stops = [self sortedStopsByDistanceWithArray:[[DataStore sharedManager] stopsBeingServicedInArray:([DataStore sharedManager].stops) ? [DataStore sharedManager].stops : [[DataStore sharedManager] persistedStops]]
                                                         location:([DataStore sharedManager].lastKnownLocation) ? [DataStore sharedManager].lastKnownLocation : [[DataStore sharedManager] persistedLastKnownLocation]];
            } else if (([DataStore sharedManager].stops || [[DataStore sharedManager] persistedStops])) {
                NSArray *array = [[DataStore sharedManager] stopsBeingServicedInArray:([DataStore sharedManager].stops) ? [DataStore sharedManager].stops : [[DataStore sharedManager] persistedStops]];
                self.stops = (array) ? array : self.stops;
            } else {
                // if there aren't any stops on file, these arrivals are useless because we have no stops to compare them against
            }
        }];
        
        [RACObserve([DataStore sharedManager], lastKnownLocation) subscribeNext:^(CLLocation *location) {
            if (([DataStore sharedManager].stops || [[DataStore sharedManager] persistedStops]) && [DataStore sharedManager].arrivals) {
                NSArray *array = ([DataStore sharedManager].stops) ? [DataStore sharedManager].stops : [[DataStore sharedManager] persistedStops];
                self.stops = [self sortedStopsByDistanceWithArray:[[DataStore sharedManager] stopsBeingServicedInArray:array] location:location];
            } else if ([DataStore sharedManager].stops || [[DataStore sharedManager] persistedStops]) {
                NSArray *array = ([DataStore sharedManager].stops) ? [DataStore sharedManager].stops : [[DataStore sharedManager] persistedStops];
                self.stops = [self sortedStopsByDistanceWithArray:array location:location];
            }
        }];
    }
    return self;
}

- (void)fetchData {
    [[DataStore sharedManager] fetchStopsWithErrorBlock:NULL];
}

- (void)reloadData {
    [self fetchData];
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:NULL];
}

- (NSArray *)sortedStopsByDistanceWithArray:(NSArray *)array location:(CLLocation *)location {
    return [array sortedArrayUsingComparator:^(id a,id b) {
        Stop *stopA = a;
        Stop *stopB = b;
        
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:[stopA.latitude doubleValue] longitude:[stopA.longitude doubleValue]];
        CLLocation *bLocation = [[CLLocation alloc] initWithLatitude:[stopB.latitude doubleValue] longitude:[stopB.longitude doubleValue]];
        
        CLLocationDistance distanceA = [aLocation distanceFromLocation:location];
        CLLocationDistance distanceB = [bLocation distanceFromLocation:location];
        
        if (distanceA < distanceB) {
            return NSOrderedAscending;
        } else if (distanceA > distanceB) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
}

@end
