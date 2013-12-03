//
//  AppDelegate.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyCCBKyJMm7zWhVxukAy8k-_ejMlc5t8ugo"];
    
    /* This looks bad
    UIColor *blue = [UIColor colorWithRed:0.007843 green:0.152941 blue:0.298039 alpha:1.0000];
    UIColor *maize = [UIColor colorWithRed:0.992157 green:0.796079 blue:0.168627 alpha:1.0000];
    
    [[UINavigationBar appearance] setBarTintColor:maize];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : blue}];
     */
    
    return YES;
}

@end
