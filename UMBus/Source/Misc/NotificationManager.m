//
//  NotificationManager.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager

- (void)scheduleNotificationWithFireDate:(NSDate *)date message:(NSString *)message {
    SendEvent(@"scheduleNotification");
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.alertBody = message;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)cancelAllScheduledNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
