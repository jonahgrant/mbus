//
//  RouteMapViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RouteMapViewControllerModel.h"
#import "UMNetworkingSession.h"
#import "Arrival.h"

@interface RouteMapViewControllerModel ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;

@end

@implementation RouteMapViewControllerModel

- (instancetype)initWithArrival:(Arrival *)arrival {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
        
        self.arrival = arrival;
    }
    return self;
}

- (void)fetchTraceRoute {
    [_networkingSession fetchTraceRouteForRouteID:self.arrival.id
                                 withSuccessBlock:^(NSArray *array) {
                                     self.traceRoutes = array;
                                 } errorBlock:NULL];
}

@end
