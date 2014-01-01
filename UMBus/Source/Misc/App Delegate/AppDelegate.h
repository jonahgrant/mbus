//
//  AppDelegate.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@class TTTLocationFormatter;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TTTLocationFormatter *locationFormatter;

+ (instancetype)sharedInstance;

@end
