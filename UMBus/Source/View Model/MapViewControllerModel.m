//
//  MapViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "MapViewControllerModel.h"
#import "BusSession.h"
#import "Bus.h"
#import "BusAnnotation.h"

@interface MapViewControllerModel ()

@property (strong, nonatomic) BusSession *session;

@end

@implementation MapViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        self.session = [[BusSession alloc] init];
        [self manageAnnotations];
    }
    return self;
}

- (void)manageAnnotations {
    [RACObserve(self, buses) subscribeNext:^(NSArray *buses) {
        if (buses) {
            NSMutableDictionary *mutableAnnotations = [NSMutableDictionary dictionaryWithDictionary:self.annotations];
            for (Bus *bus in buses) {
                if ([self.annotations objectForKey:bus.id]) {
                    // OLD BUS: update it's properties
                    [(BusAnnotation *)[mutableAnnotations objectForKey:bus.id] setCoordinate:CLLocationCoordinate2DMake([bus.latitude doubleValue], [bus.longitude doubleValue])];
                    [(BusAnnotation *)[mutableAnnotations objectForKey:bus.id] setHeading:[bus.heading floatValue]];
                } else {
                    // NEW BUS: create annotation and add to dictionary
                    BusAnnotation *annotation = [[BusAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([bus.latitude doubleValue], [bus.longitude doubleValue])
                                                                                  heading:[bus.heading floatValue]];
                    [mutableAnnotations addEntriesFromDictionary:@{bus.id : annotation}];
                }
            }
            self.annotations = mutableAnnotations;
        }
    }];
}

- (void)fetchBuses {
    NSLog(@"fetch");
    NSMutableArray *mutableArray = [NSMutableArray array];
    [self.session fetchBusLocationsWithSuccessBlock:^(NSArray *buses) {
        for (Bus *bus in buses) {
            [mutableArray addObject:bus];
        }
        self.buses = mutableArray;
        
        // update bus locations continuously
        [self fetchBuses];
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

@end
