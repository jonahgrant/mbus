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
#import "TTTArrayFormatter.h"

@interface ArrivalCellModel ()

@property (strong, nonatomic) ArrivalStop *arrivalStop;
@property (strong, nonatomic) TTTArrayFormatter *arrayFormatter;

@end

@implementation ArrivalCellModel

- (instancetype)initWithStop:(ArrivalStop *)stop forArrival:(Arrival *)arrival {
    if (self = [super init]) {
        self.stop = stop;
        self.arrival = arrival;
        self.arrivalStop = stop;
        self.arrayFormatter = [[TTTArrayFormatter alloc] init];
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
    BOOL hasBusOne = [[DataStore sharedManager] arrivalHasBus1WithArrivalID:self.arrival.id];
    BOOL hasBusTwo = [[DataStore sharedManager] arrivalHasBus2WithArrivalID:self.arrival.id];
    
    NSTimeInterval busOneInterval = self.arrivalStop.timeOfArrival;
    NSTimeInterval busTwoInterval = self.arrivalStop.timeOfArrival2;
    
    if (hasBusOne && hasBusTwo) {
        if (busOneInterval >= busTwoInterval) {
            return busTwoInterval;
        } else {
            return busOneInterval;
        }
    } else if (hasBusOne && !hasBusTwo) {
        return busOneInterval;
    } else if (!hasBusOne && hasBusTwo) {
        return busTwoInterval;
    } else {
        return -1;
    }
}

- (NSArray *)timesOfArrival {
    BOOL hasBusOne = [[DataStore sharedManager] arrivalHasBus1WithArrivalID:self.arrival.id];
    BOOL hasBusTwo = [[DataStore sharedManager] arrivalHasBus2WithArrivalID:self.arrival.id];
    
    NSMutableArray *mutableArray = [NSMutableArray array];

    if (hasBusOne) {
        [mutableArray addObject:[self timeOfArrivalForTimeInterval:self.arrivalStop.timeOfArrival]];
    }
    
    if (hasBusTwo) {
        [mutableArray addObject:[self timeOfArrivalForTimeInterval:self.arrivalStop.timeOfArrival2]];
    }
    
    return mutableArray;
}

#pragma Public

- (NSString *)abbreviatedFirstArrivalString {
    return [self abbreviatedArrivalTimeForTimeInterval:[self firstBusArrival]];
}

- (NSString *)formattedTimesOfArrival {
    return [self.arrayFormatter stringFromArray:[self timesOfArrival]];
}

@end
