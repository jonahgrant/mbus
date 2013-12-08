//
//  RouteMapViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>

@class RouteMapViewControllerModel, Arrival;

@interface RouteMapViewController : UIViewController

@property (strong, nonatomic) Arrival *arrival;
@property (strong, nonatomic) RouteMapViewControllerModel *model;

- (void)displayStreetViewForAnnotation:(NSObject<MKAnnotation> *)annotation;

@end
