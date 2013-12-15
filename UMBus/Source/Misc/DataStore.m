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
#import "Bus.h"
#import "Stop.h"

@interface DataStore ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;

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

- (void)fetchArrivalsWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchArrivalsWithSuccessBlock:^(NSArray *arrivals) {
        self.arrivals = arrivals;

        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        for (Arrival *arrival in arrivals) {
            [mutableDictionary addEntriesFromDictionary:@{arrival.id: arrival}];
        }
        self.arrivalsDictionary = mutableDictionary;
    } errorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
        [self handleError:error];
    }];
}

- (void)fetchBusesWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchBusesWithSuccessBlock:^(NSArray *buses) {
        self.buses = buses;
        
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        for (Bus *bus in buses) {
            [mutableDictionary addEntriesFromDictionary:@{bus.routeID: bus}];
        }
        self.busesForRoutesDictionary = mutableDictionary;
    } errorBlock:^(NSError *error) {
          if (errorBlock) {
            errorBlock(error);
        };
        [self handleError:error];
    }];
}

- (void)fetchStopsWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchStopsWithSuccessBlock:^(NSArray *stops) {
        self.stops = stops;
    } errorBlock:^(NSError *error) {
          if (errorBlock) {
            errorBlock(error);
        };
        [self handleError:error];
    }];
}

- (void)fetchAnnouncementsWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchAnnouncementsWithSuccessBlock:^(NSArray *announcements) {
        self.announcements = announcements;
    } errorBlock:^(NSError *error) {
          if (errorBlock) {
            errorBlock(error);
        };
        [self handleError:error];
    }];
}

#pragma 

- (Arrival *)arrivalForID:(NSString *)arrivalID {
    return [self.arrivalsDictionary objectForKey:arrivalID];
}

- (Bus *)busOperatingRouteID:(NSString *)routeID {
    return [self.busesForRoutesDictionary objectForKey:routeID];
}

- (ArrivalStop *)arrivalStopForRouteID:(NSString *)routeID stopName:(NSString *)stopName {
    for (Arrival *arrival in self.arrivals) {
        if ([arrival.id isEqualToString:routeID]) {
            for (ArrivalStop *arrivalStop in arrival.stops) {
                if ([arrivalStop.name isEqualToString:stopName]) {
                    return arrivalStop;
                }
            }
        }
    }
    
    return nil;
}

- (NSArray *)arrivalStopsForStopID:(NSString *)stopID {
    if ([self arrivals] == nil) {
        NSLog(@"No arrivals have been pulled yet.  Call -fetchArrivals before calling this method again.");
        return nil;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Arrival *arrival in self.arrivals) {
        for (ArrivalStop *stop in arrival.stops) {
            if ([stop.id1 isEqualToString:stopID]) {
                [mutableArray addObject:stop];
            }
        }
    }
    
    return mutableArray;
}

- (NSArray *)arrivalsContainingStopName:(NSString *)stopName {
    if ([self arrivals] == nil) {
        NSLog(@"No arrivals have been pulled yet.  Call -fetchArrivals before calling this method again.");
        return nil;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Arrival *arrival in self.arrivals) {
        for (ArrivalStop *stop in arrival.stops) {
            if ([stop.name isEqualToString:stopName]) {
                [mutableArray addObject:arrival];
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

- (BOOL)arrivalHasBus1WithArrivalID:(NSString *)arrivalID {
    Arrival *arrival = [self arrivalForID:arrivalID];
    NSInteger busIndex = 0;
    for (ArrivalStop *stop in arrival.stops) {
        if (stop.timeOfArrival > 0) {
            busIndex++;
        }
    }
    
    return (busIndex > 0);
}

- (BOOL)arrivalHasBus2WithArrivalID:(NSString *)arrivalID {
    Arrival *arrival = [self arrivalForID:arrivalID];
    NSInteger busIndex = 0;
    for (ArrivalStop *stop in arrival.stops) {
        if (stop.timeOfArrival2 > 0) {
            busIndex++;
        }
    }
    
    return (busIndex > 0);
}

- (NSArray *)stopsBeingServiced {
    if ([self arrivals] == nil) {
        NSLog(@"No arrivals have been pulled yet.  Call -fetchArrivals before calling this method again.");
        return nil;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Stop *stop in self.stops) {
        for (Arrival *arrival in self.arrivals) {
            for (ArrivalStop *arrivalStop in arrival.stops) {
                if ([arrivalStop.name2 isEqualToString:stop.humanName] && ![mutableArray containsObject:stop]) {
                    [mutableArray addObject:stop];
                }
            }
        }
    }
    
    return mutableArray;
}

@end
