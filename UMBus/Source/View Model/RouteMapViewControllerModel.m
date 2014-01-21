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
#import "ArrivalStop.h"
#import "TraceRoute.h"
#import "StopAnnotation.h"
#import "BusAnnotation.h"
#import "Bus.h"

@interface RouteMapViewControllerModel ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;

@end

@implementation RouteMapViewControllerModel

- (instancetype)initWithArrival:(Arrival *)arrival {
    if (self = [super init]) {
        self.arrival = arrival;
        self.networkingSession = [[UMNetworkingSession alloc] init];
        
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
                
                if (self.continuouslyFetchBuses) {
                    [self fetchBuses];
                }
            }
        }];

    }
    return self;
}

- (void)fetchStopAnnotations {
    NSMutableDictionary *mutableAnnotations = [NSMutableDictionary dictionaryWithDictionary:self.stopAnnotations];
    for (ArrivalStop *stop in self.arrival.stops) {
        if ([self.stopAnnotations objectForKey:self.arrival.id]) {
            [(StopAnnotation *)[mutableAnnotations objectForKey:stop.name] setCoordinate:CLLocationCoordinate2DMake([stop.latitude doubleValue], [stop.longitude doubleValue])];
        } else {
            StopAnnotation *annotation = [[StopAnnotation alloc] initWithArrivalStop:stop];
            [mutableAnnotations addEntriesFromDictionary:@{stop.name : annotation}];
        }
    }
    self.stopAnnotations = mutableAnnotations;
}

- (void)beginFetchingBuses {
    self.continuouslyFetchBuses = YES;
    [self fetchBuses];
}

- (void)endFetchingBuses {
    self.continuouslyFetchBuses = NO;
}

- (void)fetchBuses {
    [[DataStore sharedManager] fetchBusesWithErrorBlock:NULL];
}

- (void)fetchTraceRoute {
    if (self.arrival) {
        if ([[DataStore sharedManager] hasTraceRouteForRouteID:self.arrival.id]) {
            [self createPolylineFromTraceRoute:[[DataStore sharedManager] traceRouteForRouteID:self.arrival.id]];
        } else {
            [self.networkingSession fetchTraceRouteForRouteID:self.arrival.id
                                             withSuccessBlock:^(NSArray *traceRoute) {
                                                 [self createPolylineFromTraceRoute:traceRoute];
                                                 if (traceRoute) {
                                                     [[DataStore sharedManager] persistTraceRoute:traceRoute forRouteID:self.arrival.id];
                                                 }
                                             } errorBlock:^(NSError *error) {
                                                 self.polyline = self.polyline;
                                             }];
        }
    }
}

- (void)createPolylineFromTraceRoute:(NSArray *)traceRoute {
    dispatch_async(dispatch_get_main_queue(), ^{
        CLLocationCoordinate2D coordinates[traceRoute.count];
        for (int i = 0, n = traceRoute.count; i < n; i++) {
            TraceRoute *route = traceRoute[i];
            coordinates[i] = CLLocationCoordinate2DMake([route.latitude doubleValue], [route.longitude doubleValue]);
        }
        self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:traceRoute.count];
    });
}

@end
