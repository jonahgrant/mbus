//
//  AppDelegate.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "DataStore.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyCCBKyJMm7zWhVxukAy8k-_ejMlc5t8ugo"];
    
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:^(NSError *error) {
        
    }];
    
    [[DataStore sharedManager] fetchStopsWithErrorBlock:^(NSError *error) {
        
    }];
    
    [[DataStore sharedManager] fetchAnnouncementsWithErrorBlock:^(NSError *error) {
        
    }];
    
    [[DataStore sharedManager] fetchBusesWithErrorBlock:^(NSError *error) {
        
    }];
    
    return YES;
}

@end
