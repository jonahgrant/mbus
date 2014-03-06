//
//  AppDelegate.m
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "TTTLocationFormatter.h"
#import "LocationManager.h"
#import "DataStore.h"
#import "Constants.h"

@implementation AppDelegate

+ (instancetype)sharedInstance {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:GOOGLE_MAPS_API_KEY];

    self.locationFormatter = [[TTTLocationFormatter alloc] init];
    [self.locationFormatter.numberFormatter setMaximumSignificantDigits:2];
    self.locationFormatter.bearingStyle = TTTBearingAbbreviationWordStyle;
    self.locationFormatter.unitSystem = TTTImperialSystem;

    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:NULL];
    [[DataStore sharedManager] fetchAnnouncementsWithErrorBlock:NULL];
    
    // as long as we have stops, we don't need to reload them until the user requests it
    if (![[DataStore sharedManager] persistedStops]) {
        [[DataStore sharedManager] fetchStopsWithErrorBlock:^(NSError *error) {}];
    }
    
    [[RACSignal interval:ARRIVALS_REFRESH_INTERVAL onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        [[DataStore sharedManager] fetchArrivalsWithErrorBlock:NULL];
    }];
    
    [[LocationManager sharedManager] fetchLocation];

    return YES;
}

@end
