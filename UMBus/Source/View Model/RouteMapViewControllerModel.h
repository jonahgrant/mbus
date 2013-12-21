//
//  RouteMapViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Arrival;

@interface RouteMapViewControllerModel : NSObject

@property (strong, nonatomic) Arrival *arrival;
@property (strong, nonatomic) NSArray *traceRoute;

- (instancetype)initWithArrival:(Arrival *)arrival;

- (void)fetchTraceRoute;

@end
