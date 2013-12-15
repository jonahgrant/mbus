//
//  ArrivalsViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Arrival, ArrivalsViewControllerModel;

@interface ArrivalsViewController : UITableViewController

@property (strong, nonatomic) Arrival *arrival;
@property (strong, nonatomic) ArrivalsViewControllerModel *model;

@end
