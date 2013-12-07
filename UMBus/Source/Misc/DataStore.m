//
//  DataStore.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "DataStore.h"
#import "UMNetworkingSession.h"
#import "Arrival.h"
#import "ArrivalStop.h"

@interface DataStore ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;
@property (strong, nonatomic, readwrite) NSArray *arrivals;

@end

@implementation DataStore

#pragma mark Singleton Methods

+ (instancetype)sharedManager {
    static DataStore *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
    }
    return self;
}

- (void)handleError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

#pragma Fetch

- (void)fetchArrivals {
    [self.networkingSession fetchArrivalsWithSuccessBlock:^(NSArray *array) {
        self.arrivals = array;
    } errorBlock:^(NSError *error) {
        [self handleError:error];
    }];
}

#pragma 

- (Arrival *)arrivalForID:(NSString *)arrivalID {
    for (Arrival *arrival in self.arrivals) {
        if ([arrival.id isEqualToString:arrivalID]) {
            return arrival;
        }
    }
    
    return 0;
}

- (NSArray *)arrivalStopsForStopID:(NSString *)stopID {
    if ([self arrivals] == nil) {
        NSLog(@"No arrivals have been pulled yet.  Call -fetchArrivals before calling this method again.");
        return nil;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Arrival *arrival in self.arrivals) {
        for (ArrivalStop *stop in arrival.stops) {
            if (stop.id1 == stopID) {
                [mutableArray addObject:stop];
            }
        }
    }
    
    return mutableArray;
}

- (NSArray *)allArrivalStops {
    if ([self arrivals] == nil) {
        NSLog(@"No arrivals have been pulled yet.  Call -fetchArrivals before calling this method again.");
        return nil;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Arrival *arrival in self.arrivals) {
        for (ArrivalStop *stop in arrival.stops) {
            [mutableArray addObject:stop];
        }
    }
    return mutableArray;
}

@end
