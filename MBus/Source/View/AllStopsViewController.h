//
//  AllStopsViewController.h
//  MBus
//
//  Created by Jonah Grant on 2/25/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "UMViewController.h"

@class StopsViewControllerModel;

@interface AllStopsViewController : UMTableViewController

@property (nonatomic, strong) StopsViewControllerModel *model;

@end
