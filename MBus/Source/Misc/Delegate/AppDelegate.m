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
#import "AddressCellMapView.h"

@implementation AppDelegate

+ (instancetype)sharedInstance {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SendEvent(ANALYTICS_APP_OPENED);
    
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
    
    // analytics
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-46248477-1"];
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    
    [AddressCellMapView sharedInstance];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    SendEvent(ANALYTICS_APP_RECEIVED_LOCAL_NOTIFICATION);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    SendEvent(ANALYTICS_APP_RECEIVED_MEMORY_WARNING);
}

@end
