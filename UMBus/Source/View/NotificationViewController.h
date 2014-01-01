//
//  NotificationViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/28/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@class NotificationViewControllerModel;

@interface NotificationViewController : UITableViewController

@property (strong, nonatomic) NotificationViewControllerModel *model;
@property (nonatomic) NSDate *dateToBeNotifiedBy;

@end
