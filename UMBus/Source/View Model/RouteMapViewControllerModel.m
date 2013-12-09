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
#import "ArrivalStop.h"
#import "BusAnnotation.h"
#import "StopAnnotation.h"

@interface RouteMapViewControllerModel ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;
@property (nonatomic) BOOL continueBusUpdating;
@property (strong, nonatomic) NSArray *buses, *stops;

@end

@implementation RouteMapViewControllerModel

- (instancetype)initWithArrival:(Arrival *)arrival {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
        
        self.arrival = arrival;
        
        self.stopAnnotations = [NSDictionary dictionary];
        self.busAnnotations = [NSDictionary dictionary];
                
        [RACObserve([DataStore sharedManager], buses) subscribeNext:^(NSArray *buses) {
            if (buses) {
                NSMutableDictionary *mutableAnnotations = [NSMutableDictionary dictionaryWithDictionary:self.busAnnotations];
                for (Bus *bus in buses) {
                    if ([bus.routeID isEqualToString:self.arrival.id]) {
                        if ([self.busAnnotations objectForKey:bus.id]) {
                            [(BusAnnotation *)[mutableAnnotations objectForKey:bus.id] setCoordinate:CLLocationCoordinate2DMake([bus.latitude doubleValue], [bus.longitude doubleValue])];
                        } else {
                            BusAnnotation *annotation = [[BusAnnotation alloc] initWithBus:bus];
                            [mutableAnnotations addEntriesFromDictionary:@{bus.id : annotation}];
                        }
                    }
                }
                self.busAnnotations = mutableAnnotations;
                
                if (self.continueBusUpdating) {
                    [self fetchBuses];
                }
            }
        }];
        
        [RACObserve(self.arrival, stops) subscribeNext:^(NSArray *stops) {
            if (stops) {
                NSMutableDictionary *mutableAnnotations = [NSMutableDictionary dictionaryWithDictionary:self.stopAnnotations];
                for (ArrivalStop *stop in stops) {
                    if ([self.stopAnnotations objectForKey:self.arrival.id]) {
                        [(StopAnnotation *)[mutableAnnotations objectForKey:stop.name] setCoordinate:CLLocationCoordinate2DMake([stop.latitude doubleValue], [stop.longitude doubleValue])];
                    } else {
                        StopAnnotation *annotation = [[StopAnnotation alloc] initWithArrivalStop:stop];
                        [mutableAnnotations addEntriesFromDictionary:@{stop.name : annotation}];
                    }
                }
                self.stopAnnotations = mutableAnnotations;
            }
        }];
    }
    return self;
}

- (void)fetchTraceRoute {
    [_networkingSession fetchTraceRouteForRouteID:self.arrival.id
                                 withSuccessBlock:^(NSArray *array) {
                                     self.traceRoutes = array;
                                 } errorBlock:^(NSError *error) {
                                     self.fetchTraceRouteError = error;
                                 }];
}

- (void)fetchBuses {
    [[DataStore sharedManager] fetchBusesWithErrorBlock:^(NSError *error) {
        self.fetchBusesError = error;
    }];
}

- (void)beginBusFetching {
    self.continueBusUpdating = YES;
    [self fetchBuses];
}

- (void)endBusFetching {
    self.continueBusUpdating = NO;
}

@end
