//
//  RouteViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "UMViewController.h"

@class RouteViewControllerModel, Arrival;

@interface RouteViewController : UMTableViewController

@property (strong, nonatomic) Arrival *arrival;
@property (strong, nonatomic) RouteViewControllerModel *model;

@end
