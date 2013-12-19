//
//  StopViewControllerTitleViewModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopViewControllerTitleViewModel.h"
#import "TTTLocationFormatter.h"
#import "DataStore.h"
#import "Stop.h"

@interface StopViewControllerTitleViewModel ()

@property (strong, nonatomic) TTTLocationFormatter *locationFormatter;

@end

@implementation StopViewControllerTitleViewModel

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        self.stop = stop;
        
        self.locationFormatter = [[TTTLocationFormatter alloc] init];
        [self.locationFormatter.numberFormatter setMaximumSignificantDigits:1];
        [self.locationFormatter setUnitSystem:TTTImperialSystem];
    }
    return self;
}

- (NSString *)distance {
    if (![DataStore sharedManager].lastKnownLocation) {
        return @"Unknown distance";
    }
    
    return [self.locationFormatter stringFromDistanceFromLocation:[DataStore sharedManager].lastKnownLocation
                                                       toLocation:[[CLLocation alloc] initWithLatitude:[self.stop.latitude doubleValue] longitude:[self.stop.longitude doubleValue]]];
}

@end