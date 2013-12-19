//
//  StopViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Stop, StopViewControllerModel;

@interface StopViewController : UITableViewController

@property (strong, nonatomic) Stop *stop;
@property (strong, nonatomic) StopViewControllerModel *model;

@end