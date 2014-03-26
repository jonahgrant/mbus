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
#import "DataStore.h"
#import "UMAdditions+UIColor.h"

@interface StopCellModel ()

@property (nonatomic, strong, readwrite) Stop *stop;
@property (nonatomic, copy, readwrite) NSString *distance;
@property (nonatomic, strong, readwrite) NSArray *circleColors;

@end

@implementation StopCellModel

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        self.stop = stop;
        
        NSArray *colors = [[DataStore sharedManager] fetchColorsForStopWithUniqueName:self.stop.uniqueName];
        
        self.circleColors = (colors) ? colors : @[[UIColor blackColor]];
                
        if (![[LocationManager sharedManager] currentLocation]) {
            self.distance = UNKNOWN;
        } else {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:self.stop.latitude longitude:self.stop.longitude];

            NSString *distance = [[AppDelegate sharedInstance].locationFormatter stringFromDistanceFromLocation:[[LocationManager sharedManager] currentLocation]
                                                                                                     toLocation:location];
            distance = [distance stringByReplacingOccurrencesOfString:@"miles" withString:@"mi"];
            distance = [distance stringByReplacingOccurrencesOfString:@"yards" withString:@"yds"];
            distance = [distance stringByReplacingOccurrencesOfString:@"feet" withString:@"ft"];
            
            self.distance = distance;
        }
    }
    return self;
}

- (NSString *)initialsForStop:(NSString *)stopName {
    stopName = [stopName stringByReplacingOccurrencesOfString:@"at" withString:@""];
    stopName = [stopName stringByReplacingOccurrencesOfString:@"in" withString:@""];
    stopName = [stopName stringByReplacingOccurrencesOfString:@"-" withString:@" "]; // seperate words that have a hyphen
    stopName = [stopName stringByReplacingOccurrencesOfString:@"(" withString:@""];
    stopName = [stopName stringByReplacingOccurrencesOfString:@")" withString:@""];
    stopName = [stopName stringByReplacingOccurrencesOfString:@"temp" withString:@""];
    stopName = [stopName stringByReplacingOccurrencesOfString:@"II" withString:@""];
    stopName = [stopName stringByReplacingOccurrencesOfString:@"St." withString:@""];
    stopName = [stopName stringByReplacingOccurrencesOfString:@"st." withString:@""];
    stopName = [stopName stringByReplacingOccurrencesOfString:@"(no longer served)" withString:@""];

    NSArray *words = [stopName componentsSeparatedByString:@" "];
    NSString *initials = [NSString string];
    
    for (NSString *word in words) {
        if (![word isEqual:@""]) {
            initials = [initials stringByAppendingString:[word substringToIndex:1]];
        }
    }
    
    return initials.uppercaseString;
}

@end
