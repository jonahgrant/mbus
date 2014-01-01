//
//  NotificationManager.h
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@interface NotificationManager : NSObject

- (void)scheduleNotificationWithFireDate:(NSDate *)date message:(NSString *)message;
- (void)cancelAllScheduledNotifications;

@end
