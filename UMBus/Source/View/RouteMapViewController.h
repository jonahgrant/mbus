//
//  RouteMapViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RouteMapViewControllerModel, Arrival;

@interface RouteMapViewController : UIViewController

@property (strong, nonatomic) RouteMapViewControllerModel *model;
@property (strong, nonatomic) Arrival *arrival;

@end
