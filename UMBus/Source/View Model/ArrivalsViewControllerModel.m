//
//  ArrivalsViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalsViewControllerModel.h"
#import "Arrival.h"
#import "ArrivalStop.h"

@implementation ArrivalsViewControllerModel

- (instancetype)initWithArrival:(Arrival *)arrival {
    if (self = [super init]) {
        self.arrival = arrival;
        
        [RACObserve(self, arrival) subscribeNext:^(Arrival *arrival) {
            self.stopsSortedByTimeOfArrival = [self stopsOrderedByTimeOfArrivalWithStops:arrival.stops];
        }];
    }
    return self;
}

- (NSArray *)stopsOrderedByTimeOfArrivalWithStops:(NSArray *)stops {
     return [stops sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        ArrivalStop *a = obj1;
        ArrivalStop *b = obj2;
        
        if (a.timeOfArrival < b.timeOfArrival) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (a.timeOfArrival > b.timeOfArrival) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
}

- (NSString *)mmssForTimeInterval:(NSTimeInterval)timeInterval {
    return [NSString stringWithFormat:@"%02i:%02i", ((NSInteger)timeInterval / 60) % 60, (NSInteger)timeInterval % 60];
}

@end
