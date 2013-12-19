//
//  StopArrivalCellModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopArrivalCellModel.h"
#import "DataStore.h"
#import "Arrival.h"
#import "Stop.h"
#import "ArrivalStop.h"

@implementation StopArrivalCellModel

- (instancetype)initWithArrival:(Arrival *)arrival stop:(Stop *)stop {
    if (self = [super init]) {
        self.stop = stop;
        self.arrival = arrival;
    }
    return self;
}

- (ArrivalStop *)arrivalStop {
    return [[DataStore sharedManager] arrivalStopForRouteID:self.arrival.id stopName:self.stop.uniqueName];
}

- (NSString *)abbreviatedArrivalTimeForTimeInterval:(NSTimeInterval)timeInterval {
    if (timeInterval == -1) {
        return @"unknown time";
    }
    
    int minutes = ((NSInteger)timeInterval / 60) % 60;
    if (minutes == 00) {
        return @"now";
    }
    
    return [NSString stringWithFormat:@"%02i minutes", minutes];
}

- (NSString *)arrivalPrefixTimeForTimeInterval:(NSTimeInterval)timeInterval {
    if (timeInterval == -1) {
        return @"--";
    }
    
    int minutes = ((NSInteger)timeInterval / 60) % 60;
    if (minutes == 00) {
        return @"Arriving";
    }
    
    return @"Arriving in";
}

- (NSTimeInterval)firstArrival {
    NSTimeInterval toa = 0;
    if ([[DataStore sharedManager] arrivalHasBus1WithArrivalID:self.arrival.id] &&
        [[DataStore sharedManager] arrivalHasBus2WithArrivalID:self.arrival.id]) {
        if ([self arrivalStop].timeOfArrival >= [self arrivalStop].timeOfArrival2) {
            toa = [self arrivalStop].timeOfArrival2;
        } else {
            toa = [self arrivalStop].timeOfArrival;
        }
    } else if ([[DataStore sharedManager] arrivalHasBus1WithArrivalID:self.arrival.id] &&
               ![[DataStore sharedManager] arrivalHasBus2WithArrivalID:self.arrival.id]) {
        toa = [self arrivalStop].timeOfArrival;
    } else if (![[DataStore sharedManager] arrivalHasBus1WithArrivalID:self.arrival.id] &&
               [[DataStore sharedManager] arrivalHasBus2WithArrivalID:self.arrival.id]) {
        toa = [self arrivalStop].timeOfArrival2;
    } else {
        toa = -1;
    }

    return toa;
}

@end
