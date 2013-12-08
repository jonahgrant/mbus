//
//  RouteMapViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RouteMapViewControllerModel.h"
#import "UMNetworkingSession.h"
#import "DataStore.h"
#import "Arrival.h"
#import "Bus.h"

@interface RouteMapViewControllerModel ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;

@end

@implementation RouteMapViewControllerModel

- (instancetype)initWithArrival:(Arrival *)arrival {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
        
        self.arrival = arrival;
        
        [RACObserve([DataStore sharedManager], busesForRoutesDictionary) subscribeNext:^(NSDictionary *busDictionary) {
            if (busDictionary) {
                self.bus = [busDictionary objectForKey:self.arrival.id];
            }
        }];
    }
    return self;
}

- (void)fetchTraceRoute {
    [_networkingSession fetchTraceRouteForRouteID:self.arrival.id
                                 withSuccessBlock:^(NSArray *array) {
                                     self.traceRoutes = array;
                                 } errorBlock:NULL];
}

- (void)fetchBus {
    [[DataStore sharedManager] fetchBuses];
}

@end
