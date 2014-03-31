//
//  NotifyViewController.h
//  MBus
//
//  Created by Jonah Grant on 3/30/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "UMViewController.h"

@class Arrival, Stop;

@interface NotifyViewController : UMTableViewController

@property (strong, nonatomic) Arrival *arrival;
@property (strong, nonatomic) Stop *stop;

@end
