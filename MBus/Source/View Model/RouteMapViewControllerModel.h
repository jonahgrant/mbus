//
//  RouteMapViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ViewControllerModelBase.h"

@import MapKit;

@class Arrival;

@interface RouteMapViewControllerModel : ViewControllerModelBase

@property (nonatomic) BOOL continuouslyFetchBuses;
@property (strong, nonatomic) Arrival *arrival;
@property (strong, nonatomic) MKPolyline *polyline;
@property (strong, nonatomic) NSDictionary *stopAnnotations, *busAnnotations;

- (instancetype)initWithArrival:(Arrival *)arrival;

- (void)fetchTraceRoute;
- (void)fetchStopAnnotations;
- (void)beginFetchingBuses;
- (void)endFetchingBuses;

@end
