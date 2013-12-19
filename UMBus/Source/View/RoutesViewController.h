//
//  RoutesViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoutesViewControllerModel;

@interface RoutesViewController : UITableViewController

@property (strong, nonatomic) RoutesViewControllerModel *model;

@end
