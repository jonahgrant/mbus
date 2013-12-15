//
//  LocationManager.m
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation LocationManager

#pragma mark Singleton Methods

+ (instancetype)sharedManager {
    static LocationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return self;
}

#pragma CLLocation

- (void)fetchLocation {
    [self.locationManager startUpdatingLocation];
}

#pragma CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    
    CLLocationDistance distance = [oldLocation distanceFromLocation:newLocation];
    if (!oldLocation) {
        self.currentLocation = newLocation;
    } else if (distance >= 300) {
        self.currentLocation = newLocation;
    }
}

@end
