//
//  AnnouncementsViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnnouncementsViewControllerModel;

@interface AnnouncementsViewController : UITableViewController

@property (strong, nonatomic) AnnouncementsViewControllerModel *model;

@end
