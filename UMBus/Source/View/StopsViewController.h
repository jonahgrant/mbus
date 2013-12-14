//
//  StopsViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StopsViewControllerModel;

@interface StopsViewController : UITableViewController

@property (strong, nonatomic) StopsViewControllerModel *model;

@end
