//
//  StopAnnotation.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopAnnotation.h"
#import "ArrivalStop.h"

@interface StopAnnotation ()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation StopAnnotation

- (instancetype)initWithArrivalStop:(ArrivalStop *)stop {
    if (self = [super init]) {
        _coordinate = CLLocationCoordinate2DMake([stop.latitude doubleValue], [stop.longitude doubleValue]);
        _stop = stop;
    }
    return self;
}

- (NSString *)title {
    return _stop.name2;
}

- (NSString *)subtitle {
    return [self abbreviatedArrivalTime];
}

- (NSString *)abbreviatedArrivalTime {
    int minutes = ((NSInteger)self.stop.timeOfArrival / 60) % 60;
    if (minutes == 00) {
        return @"Arriving now";
    }
    
    return [NSString stringWithFormat:@"Arriving in %02im", minutes];
}

@end
