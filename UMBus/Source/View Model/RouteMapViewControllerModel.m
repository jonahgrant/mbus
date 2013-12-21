//
//  RouteMapViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RouteMapViewControllerModel.h"
#import "UMNetworkingSession.h"
#import "DataStore.h"
#import "Arrival.h"

@interface RouteMapViewControllerModel ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;

@end

@implementation RouteMapViewControllerModel

- (instancetype)initWithArrival:(Arrival *)arrival {
    if (self = [super init]) {
        self.arrival = arrival;
        self.networkingSession = [[UMNetworkingSession alloc] init];
    }
    return self;
}

- (void)fetchTraceRoute {
    if (self.arrival) {
        if ([[DataStore sharedManager] hasTraceRouteForRouteID:self.arrival.id]) {
            self.traceRoute = [[DataStore sharedManager] traceRouteForRouteID:self.arrival.id];
        } else {
            [self.networkingSession fetchTraceRouteForRouteID:self.arrival.id
                                             withSuccessBlock:^(NSArray *traceRoute) {
                                                 self.traceRoute = traceRoute;
                                                 [[DataStore sharedManager] persistTraceRoute:traceRoute forRouteID:self.arrival.id];
                                             } errorBlock:^(NSError *error) {
                                                 self.traceRoute = self.traceRoute;
                                             }];
        }
    }
}

@end
