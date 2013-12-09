//
//  ArrivalCellModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalCellModel.h"
#import "ArrivalStop.h"

@implementation ArrivalCellModel

- (instancetype)initWithStop:(ArrivalStop *)stop {
    if (self = [super init]) {
        self.stop = stop;
    }
    return self;
}

- (NSString *)abbreviatedArrivalTimeForTimeInterval:(NSTimeInterval)timeInterval {
    int minutes = ((NSInteger)timeInterval / 60) % 60;
    if (minutes == 00) {
        return @"Arr";
    }
    
    return [NSString stringWithFormat:@"%02im", minutes];
}

@end
