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
#import "BusAnnotation.h"

@interface RouteMapViewControllerModel ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;
@property (nonatomic) BOOL continueBusUpdating;
@property (strong, nonatomic) NSDictionary *busDictionary;

@end

@implementation RouteMapViewControllerModel

- (instancetype)initWithArrival:(Arrival *)arrival {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
        
        self.arrival = arrival;
        
        self.busDictionary = [NSDictionary dictionary];
        
        [RACObserve([DataStore sharedManager], buses) subscribeNext:^(NSArray *buses) {
            if (buses) {
                for (Bus *bus in buses) {
                    if ([bus.routeID isEqualToString:self.arrival.id]) {
                        if (self.busAnnotation) {
                            [self.busAnnotation setCoordinate:CLLocationCoordinate2DMake([bus.latitude doubleValue], [bus.longitude doubleValue])];
                        } else {
                            self.busAnnotation = [[BusAnnotation alloc] initWithBus:bus];
                        }
                    }
                }
                
                if (self.continueBusUpdating) {
                    [self fetchBuses];
                }
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

- (void)fetchBuses {
    [[DataStore sharedManager] fetchBuses];
}

- (void)beginBusFetching {
    self.continueBusUpdating = YES;
    [self fetchBuses];
}

- (void)endBusFetching {
    self.continueBusUpdating = NO;
}

@end
