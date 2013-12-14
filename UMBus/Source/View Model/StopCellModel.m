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
#import "Stop.h"

@interface StopCellModel ()

@property (strong, nonatomic) TTTLocationFormatter *locationFormatter;

@end

@implementation StopCellModel

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        self.stop = stop;
        
        self.locationFormatter = [[TTTLocationFormatter alloc] init];
        [self.locationFormatter.numberFormatter setMaximumSignificantDigits:4];
        [self.locationFormatter setUnitSystem:TTTImperialSystem];
    }
    return self;
}

- (NSString *)distance {
    if (![[LocationManager sharedManager] currentLocation]) {
        return @"Unknown distance";
    }
    
    return [self.locationFormatter stringFromDistanceFromLocation:[[LocationManager sharedManager] currentLocation]
                                                       toLocation:[[CLLocation alloc] initWithLatitude:[self.stop.latitude doubleValue] longitude:[self.stop.longitude doubleValue]]];
}

@end
