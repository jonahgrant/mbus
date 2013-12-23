//
//  ArrivalCellModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalCellModel.h"
#import "DataStore.h"
#import "ArrivalStop.h"
#import "Arrival.h"

@interface ArrivalCellModel ()

@property (strong, nonatomic) ArrivalStop *arrivalStop;

@end
@implementation ArrivalCellModel

- (instancetype)initWithStop:(ArrivalStop *)stop forArrival:(Arrival *)arrival {
    if (self = [super init]) {
        self.stop = stop;
        self.arrival = arrival;

        self.arrivalStop = [[DataStore sharedManager] arrivalStopForRouteID:self.arrival.id stopName:self.stop.name2];
        self.firstArrival = [self firstBusArrival];
        self.firstArrivalString = [self abbreviatedArrivalTimeForTimeInterval:self.firstArrival];
    }
    return self;
}

- (NSString *)abbreviatedArrivalTimeForTimeInterval:(NSTimeInterval)timeInterval {
    if (timeInterval == -1) {
        return @"--";
    }
    
    int minutes = ((NSInteger)timeInterval / 60) % 60;
    if (minutes == 00) {
        return @"Arr";
    }
    
    return [NSString stringWithFormat:@"%02im", minutes];
}

- (NSString *)timeOfArrivalForTimeInterval:(NSTimeInterval)interval {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate *date = [NSDate dateWithTimeInterval:interval sinceDate:[[DataStore sharedManager] arrivalsTimestamp]];
    return [dateFormatter stringFromDate:date];
}

- (NSTimeInterval)firstBusArrival {
    NSTimeInterval toa = 0;
    if ([[DataStore sharedManager] arrivalHasBus1WithArrivalID:self.arrival.id] &&
        [[DataStore sharedManager] arrivalHasBus2WithArrivalID:self.arrival.id]) {
        if (self.arrivalStop.timeOfArrival >= self.arrivalStop.timeOfArrival2) {
            toa = self.arrivalStop.timeOfArrival2;
        } else {
            toa = self.arrivalStop.timeOfArrival;
        }
    } else if ([[DataStore sharedManager] arrivalHasBus1WithArrivalID:self.arrival.id] &&
               ![[DataStore sharedManager] arrivalHasBus2WithArrivalID:self.arrival.id]) {
        toa = self.arrivalStop.timeOfArrival;
    } else if (![[DataStore sharedManager] arrivalHasBus1WithArrivalID:self.arrival.id] &&
               [[DataStore sharedManager] arrivalHasBus2WithArrivalID:self.arrival.id]) {
        toa = self.arrivalStop.timeOfArrival2;
    } else {
        toa = -1;
    }
    
    return toa;
}

@end
