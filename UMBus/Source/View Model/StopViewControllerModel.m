//
//  StopViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopViewControllerModel.h"
#import "Stop.h"
#import "Arrival.h"
#import "ArrivalStop.h"
#import "DataStore.h"

@implementation StopViewControllerModel

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        self.stop = stop;
        [self updateArrivals];
        
        [RACObserve([DataStore sharedManager], arrivals) subscribeNext:^(NSArray *arrivals) {
            [self updateArrivals];
        }];
    }
    return self;
}

- (void)updateArrivals {
    self.arrivalsServicingStop = [[DataStore sharedManager] arrivalsContainingStopName:self.stop.uniqueName];
}

- (void)fetchData {
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:^(NSError *error) {
        self.arrivalsServicingStop = self.arrivalsServicingStop;
    }];
}

- (ArrivalStop *)arrivalStopForArrival:(Arrival *)arrival {
    return [[DataStore sharedManager] arrivalStopForRouteID:arrival.id stopName:self.stop.uniqueName];
}

- (NSTimeInterval)firstArrivalTimeIntervalForArrival:(Arrival *)arrival {
    ArrivalStop *arrivalStop = [self arrivalStopForArrival:arrival];
    
    NSTimeInterval toa = 0;
    if ([[DataStore sharedManager] arrivalHasBus1WithArrivalID:arrival.id] &&
        [[DataStore sharedManager] arrivalHasBus2WithArrivalID:arrival.id]) {
        if (arrivalStop.timeOfArrival >= arrivalStop.timeOfArrival2) {
            toa = arrivalStop.timeOfArrival2;
        } else {
            toa = arrivalStop.timeOfArrival;
        }
    } else if ([[DataStore sharedManager] arrivalHasBus1WithArrivalID:arrival.id] &&
               ![[DataStore sharedManager] arrivalHasBus2WithArrivalID:arrival.id]) {
        toa = arrivalStop.timeOfArrival;
    } else if (![[DataStore sharedManager] arrivalHasBus1WithArrivalID:arrival.id] &&
               [[DataStore sharedManager] arrivalHasBus2WithArrivalID:arrival.id]) {
        toa = arrivalStop.timeOfArrival2;
    } else {
        toa = -1;
    }
    
    return toa;
}

- (NSDate *)firstArrivalDateForArrival:(Arrival *)arrival {
    NSTimeInterval timeInterval = [self firstArrivalTimeIntervalForArrival:arrival];
    if (timeInterval == -1) {
        return nil;
    }
    
    return [NSDate dateWithTimeInterval:(timeInterval > 300) ? timeInterval - 120 : timeInterval // notify two minutes before the bus arrives
                              sinceDate:[[DataStore sharedManager] arrivalsTimestamp]];
}

@end
