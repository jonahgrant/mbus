//
//  RouteMapViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Arrival, Bus;

@interface RouteMapViewControllerModel : NSObject

@property (strong, nonatomic) Arrival *arrival;
@property (strong, nonatomic) Bus *bus;
@property (strong, nonatomic) NSArray *traceRoutes;

- (instancetype)initWithArrival:(Arrival *)arrival;

- (void)fetchTraceRoute;
- (void)fetchBus;

@end
