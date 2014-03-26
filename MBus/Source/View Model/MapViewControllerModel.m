//
//  MapViewControllerModel.m
//  MBus
//
//  Created by Jonah Grant on 3/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "MapViewControllerModel.h"
#import "DataStore.h"
#import "Bus.h"
#import "Arrival.h"
#import "BusAnnotation.h"

@interface MapViewControllerModel ()

@property (nonatomic, strong, readwrite) NSDictionary *busAnnotations;
@property (nonatomic, readwrite, getter=isFetchingBuses) BOOL fetchingContinuously;
@property (nonatomic, strong, readwrite) NSArray *routes;

- (void)refreshData;
- (void)manageBusAnnotations;

@end

@implementation MapViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        [[RACObserve([DataStore sharedManager], buses) filter:^BOOL(NSArray *buses) {
            return (buses.count > 0);
        }] subscribeNext:^(NSArray *buses) {
            [self manageBusAnnotations];

            if (self.fetchingContinuously) {
                [self fetchData];
            } else {
                [self endContinuousFetching];
            }
        }];
        
        [[RACObserve(self, busAnnotations) filter:^BOOL(NSDictionary *annotations) {
            return (annotations.count > 0 && self.dataUpdatedBlock);
        }] subscribeNext:^(NSDictionary *annotations) {
            self.dataUpdatedBlock();
        }];
    }
    return self;
}

#pragma mark - ViewControllerModelBase

- (void)fetchData {
    [[DataStore sharedManager] fetchBusesWithErrorBlock:NULL];
}

#pragma mark - Private

- (void)refreshData {
    self.busAnnotations = nil;
    [self fetchData];
}

- (void)manageBusAnnotations {
    NSMutableDictionary *mutableAnnotations = [NSMutableDictionary dictionaryWithDictionary:self.busAnnotations];
    
    for (Bus *bus in [DataStore sharedManager].buses) {
        if ([self.busAnnotations objectForKey:bus.id]) {
            // OLD BUS: update it's properties
            [(BusAnnotation *)[mutableAnnotations objectForKey:bus.id] setCoordinate:bus.coordinate];
            [(BusAnnotation *)[mutableAnnotations objectForKey:bus.id] setHeading:[bus.heading floatValue]];
        } else {
            // NEW BUS: create annotation and add to dictionary
            BusAnnotation *annotation = [[BusAnnotation alloc] initWithBus:bus];
            [mutableAnnotations addEntriesFromDictionary:@{bus.id : annotation}];
        }
    }
    
    self.busAnnotations = mutableAnnotations;
}

#pragma mark - Public

- (void)beginContinuousFetching {
    self.fetchingContinuously = YES;
    [self fetchData];
}

- (void)endContinuousFetching {
    self.fetchingContinuously = NO;
}

@end
