//
//  StopCellModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopCellModel.h"
#import "TTTLocationFormatter.h"
#import "LocationManager.h"
#import "AppDelegate.h"
#import "Stop.h"
#import "Constants.h"

@implementation StopCellModel

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        self.stop = stop;
    }
    return self;
}

- (NSString *)distance {
    if (![[LocationManager sharedManager] currentLocation]) {
        return kErrorUnknownDistance;
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.stop.latitude doubleValue] longitude:[self.stop.longitude doubleValue]];
    
    return [[AppDelegate sharedInstance].locationFormatter stringFromDistanceFromLocation:[[LocationManager sharedManager] currentLocation]
                                                                               toLocation:location];
}

@end
