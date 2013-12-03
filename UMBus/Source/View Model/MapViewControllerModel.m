//
//  MapViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "MapViewControllerModel.h"
#import "UMNetworkingSession.h"
#import "Bus.h"
#import "BusAnnotation.h"
#import "Stop.h"
#import "StopAnnotation.h"
#import "Route.h"

@interface MapViewControllerModel ()

@property (strong, nonatomic) UMNetworkingSession *session;

@end

@implementation MapViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        self.session = [[UMNetworkingSession alloc] init];
        [self manageBusAnnotations];
        [self manageStopAnnotations];
        
        _streetViewBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Street View" style:UIBarButtonItemStylePlain target:nil action:nil];
        _directionsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Directions" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}

- (void)fetchBuses {
    [self.session fetchBusLocationsWithSuccessBlock:^(NSArray *buses) {
        self.buses = buses;
        
        // update bus locations continuously
        [self fetchBuses];
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

- (void)manageBusAnnotations {
    [RACObserve(self, buses) subscribeNext:^(NSArray *buses) {
        if (buses) {
            NSMutableDictionary *mutableAnnotations = [NSMutableDictionary dictionaryWithDictionary:self.busAnnotations];
            for (Bus *bus in buses) {
                if ([self.busAnnotations objectForKey:bus.id]) {
                    // OLD BUS: update it's properties
                    [(BusAnnotation *)[mutableAnnotations objectForKey:bus.id] setCoordinate:CLLocationCoordinate2DMake([bus.latitude doubleValue], [bus.longitude doubleValue])];
                    [(BusAnnotation *)[mutableAnnotations objectForKey:bus.id] setHeading:[bus.heading floatValue]];
                } else {
                    // NEW BUS: create annotation and add to dictionary
                    BusAnnotation *annotation = [[BusAnnotation alloc] initWithBus:bus];
                    [mutableAnnotations addEntriesFromDictionary:@{bus.id : annotation}];
                }
            }
            self.busAnnotations = mutableAnnotations;
        }
    }];
}

- (void)fetchStops {
    [self.session fetchStopsWithSuccessBlock:^(NSArray *stops) {
        self.stops = stops;
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

- (void)manageStopAnnotations {
    [RACObserve(self, stops) subscribeNext:^(NSArray *stops) {
        if (stops) {
            NSMutableDictionary *mutableAnnotations = [NSMutableDictionary dictionaryWithDictionary:self.stopAnnotations];
            for (Stop *stop in stops) {
                if ([self.stopAnnotations objectForKey:stop.id]) {
                    // OLD STOP: update it's properties
                    [(StopAnnotation *)[mutableAnnotations objectForKey:stop.id] setCoordinate:CLLocationCoordinate2DMake([stop.latitude doubleValue], [stop.longitude doubleValue])];
                } else {
                    // NEW STOP: create annotation and add to dictionary
                    StopAnnotation *annotation = [[StopAnnotation alloc] initWithStop:stop];
                    [mutableAnnotations addEntriesFromDictionary:@{stop.id : annotation}];
                }
            }
            self.stopAnnotations = mutableAnnotations;
        }
    }];
}

@end
