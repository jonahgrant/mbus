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
#import "AppDelegate.h"
#import "Constants.h"

@interface StopViewControllerTitleViewModel ()

@property (strong, nonatomic, readwrite) Stop *stop;

@end

@implementation StopViewControllerTitleViewModel

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        self.stop = stop;
    }
    return self;
}

- (NSString *)distance {
    if (![DataStore sharedManager].lastKnownLocation) {
        return @"Unknown distance";
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.stop.latitude longitude:self.stop.longitude];
    
    return [[AppDelegate sharedInstance].locationFormatter stringFromDistanceFromLocation:[DataStore sharedManager].lastKnownLocation
                                                                               toLocation:location];
}

@end
