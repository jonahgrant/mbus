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
#import "AFHTTPRequestOperationManager.h"
#import "UMResponseSerializer.h"
#import "AppAnnouncement.h"
#import "SUPGridWindow.h"

@interface AppDelegate ()

@property (strong, nonatomic, readwrite) AFHTTPRequestOperationManager *manager;

@end

@implementation AppDelegate

+ (instancetype)sharedInstance {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SendEvent(ANALYTICS_APP_OPENED);
    
    [GMSServices provideAPIKey:GOOGLE_MAPS_API_KEY];

    self.manager = [AFHTTPRequestOperationManager manager];
    [self fetchAppAnnouncements];
    
#if DEBUG
    /*
    SUPGridWindow *grid = [SUPGridWindow sharedGridWindow];
    [grid setGridColor:[UIColor redColor]];
    [grid setMajorGridSize:CGSizeMake(40, 40)];
     */
#endif
    
#ifndef DEBUG
    // analytics
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-46248477-1"];
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
#endif
    
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
    
    //[AddressCellMapView sharedInstance];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    SendEvent(ANALYTICS_APP_RECEIVED_LOCAL_NOTIFICATION);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    SendEvent(ANALYTICS_APP_RECEIVED_MEMORY_WARNING);
}

- (void)fetchAppAnnouncements {
    AFHTTPRequestOperation *operation = [self.manager GET:@"http://jonahgrant.com/mbus/announcements/announcements.json"
                                               parameters:nil
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      NSArray *announcements = (NSArray *)responseObject;
                                                      NSMutableArray *mutableArray = [NSMutableArray array];
                                                      for (AppAnnouncement *announcement in announcements) {
                                                          if (announcement.supported) {
                                                              [mutableArray addObject:announcement];
                                                          }
                                                      }
                                                      self.appAnnouncements = mutableArray;
                                                  } failure:NULL];
    [operation setResponseSerializer:[AppAnnouncement um_jsonArrayResponseSerializer]];
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        return nil;
    }];
    [operation start];
}

@end
