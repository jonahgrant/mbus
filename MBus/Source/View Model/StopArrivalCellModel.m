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
        self.firstArrival = [self firstBusArrival];
        self.firstArrivalSuffix = [self arrivalSuffixTimeForTimeInterval:self.firstArrival];
        self.firstArrivalString = [self abbreviatedArrivalTimeForTimeInterval:self.firstArrival];
    }
    return self;
}

- (ArrivalStop *)arrivalStop {
    return [[DataStore sharedManager] arrivalStopForRouteID:self.arrival.id stopName:self.stop.uniqueName];
}

- (NSString *)abbreviatedArrivalTimeForTimeInterval:(NSTimeInterval)timeInterval {
    if (timeInterval == -1) {
        return @"--";
    }
    
    int minutes = ((NSInteger)timeInterval / 60) % 60;
    if (minutes == 00) {
        return @"Arriving Now";
    }
    
    return [NSString stringWithFormat:@"%02i", minutes];
}

- (NSString *)arrivalSuffixTimeForTimeInterval:(NSTimeInterval)timeInterval {
    if (timeInterval == -1) {
        return @"";
    }
    
    int minutes = ((NSInteger)timeInterval / 60) % 60;
    if (minutes == 00) {
        return @"";
    } else if (minutes == 1) {
        return @"minute";
    }
    
    if (timeInterval > 60) {
        return @"minutes";
    }

    return @"minute";
}

- (NSTimeInterval)firstBusArrival {
    NSTimeInterval toa = 0;
    BOOL hasBus1 = [[DataStore sharedManager] arrivalHasBus1WithArrivalID:self.arrival.id];
    BOOL hasBus2 = [[DataStore sharedManager] arrivalHasBus2WithArrivalID:self.arrival.id];
    
    if (hasBus1 && hasBus2) {
        if ([self arrivalStop].timeOfArrival >= [self arrivalStop].timeOfArrival2) {
            toa = [self arrivalStop].timeOfArrival2;
        } else {
            toa = [self arrivalStop].timeOfArrival;
        }
    } else if (hasBus1 && !hasBus2) {
        toa = [self arrivalStop].timeOfArrival;
    } else if (!hasBus1 && hasBus2) {
        toa = [self arrivalStop].timeOfArrival2;
    } else {
        toa = -1;
    }

    return toa;
}

@end
