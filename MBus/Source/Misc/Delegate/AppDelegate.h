//
//  AppDelegate.h
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

@class TTTLocationFormatter;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TTTLocationFormatter *locationFormatter;

+ (instancetype)sharedInstance;

@end
