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
@property (strong, nonatomic) NSArray *buses;

@end

@implementation RouteMapViewControllerModel

- (instancetype)initWithArrival:(Arrival *)arrival {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
        
        self.arrival = arrival;
                
        [RACObserve([DataStore sharedManager], buses) subscribeNext:^(NSArray *buses) {
            if (buses) {
                self.buses = buses;
                [self manageBusAnnotations];
                
                if (self.continueBusUpdating) {
                    [self fetchBuses];
                }
            }
        }];
    }
    return self;
}

- (void)manageBusAnnotations {
    [RACObserve(self, buses) subscribeNext:^(NSArray *buses) {
        if (buses) {
            NSMutableDictionary *mutableAnnotations = [NSMutableDictionary dictionaryWithDictionary:self.busAnnotations];
            for (Bus *bus in buses) {
                if ([bus.routeID isEqualToString:self.arrival.id]) {
                    if ([self.busAnnotations objectForKey:bus.id]) {
                        // update
                        [(BusAnnotation *)[mutableAnnotations objectForKey:bus.id] setCoordinate:CLLocationCoordinate2DMake([bus.latitude doubleValue], [bus.longitude doubleValue])];
                    } else {
                        // add
                        BusAnnotation *annotation = [[BusAnnotation alloc] initWithBus:bus];
                        [mutableAnnotations addEntriesFromDictionary:@{bus.id : annotation}];
                    }
                }
            }
            self.busAnnotations = mutableAnnotations;
        }
    }];
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
