//
//  DataStore.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "DataStore.h"
#import "UMNetworkingSession.h"
#import "LocationManager.h"
#import "Arrival.h"
#import "ArrivalStop.h"
#import "Bus.h"
#import "Stop.h"

static NSString * kLastKnownLocation = @"lastKnownLocation.txt";
static NSString * kStopsFile = @"stops.txt";
static NSString * kBusesFile = @"buses.txt";
static NSString * kAnnouncementsFile = @"announcements.txt";
static NSString * kArrivalsFile = @"arrivals.txt";

@interface DataStore ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;
@property (strong, nonatomic) NSDictionary *arrivalsDictionary;

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
        
        [RACObserve([LocationManager sharedManager], currentLocation) subscribeNext:^(CLLocation *location) {
            if (location) {
                self.lastKnownLocation = location;
                [self persistArray:@[location] withFileName:kLastKnownLocation];
            }
        }];
    }
    return self;
}

- (void)handleError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)persistArray:(NSArray *)array withFileName:(NSString *)fileName {
    [[NSKeyedArchiver archivedDataWithRootObject:array] writeToFile:[self filePathWithName:fileName] atomically:YES];
}

- (NSString *)filePathWithName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (NSArray *)persistedArrayWithFileName:(NSString *)fileName {
    NSData *data = [NSData dataWithContentsOfFile:[self filePathWithName:fileName]];
    if (!data) {
        return nil;
    }
    
    return [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
}

#pragma Properties

- (NSArray *)persistedArrivals {
    return [self persistedArrayWithFileName:kArrivalsFile];
}

- (NSArray *)persistedBuses {
    return [self persistedArrayWithFileName:kBusesFile];
}

- (NSArray *)persistedStops {
    return [self persistedArrayWithFileName:kStopsFile];
}

- (NSArray *)persistedAnnouncements {
    return [self persistedArrayWithFileName:kAnnouncementsFile];
}

- (CLLocation *)persistedLastKnownLocation {
    return (CLLocation *)[self persistedArrayWithFileName:kLastKnownLocation][0];
}

#pragma Fetch

- (void)fetchArrivalsWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchArrivalsWithSuccessBlock:^(NSArray *arrivals) {
        [self persistArray:arrivals withFileName:kArrivalsFile];
        self.arrivals = arrivals;
        self.arrivalsTimestamp = [NSDate date];
        
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        for (Arrival *arrival in arrivals) {
            [mutableDictionary addEntriesFromDictionary:@{arrival.id: arrival}];
        }
        self.arrivalsDictionary = mutableDictionary;
    } errorBlock:^(NSError *error) {
        self.arrivalsTimestamp = [NSDate date];
        if (errorBlock) {
            errorBlock(error);
        }
        [self handleError:error];
    }];
}

- (void)fetchBusesWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchBusesWithSuccessBlock:^(NSArray *buses) {
        [self persistArray:buses withFileName:kBusesFile];
        self.buses = buses;
        self.busesTimestamp = [NSDate date];
        } errorBlock:^(NSError *error) {
            self.busesTimestamp = [NSDate date];
          if (errorBlock) {
            errorBlock(error);
        };
        [self handleError:error];
    }];
}

- (void)fetchStopsWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchStopsWithSuccessBlock:^(NSArray *stops) {
        [self persistArray:stops withFileName:kStopsFile];
        self.stops = stops;
        self.stopsTimestamp = [NSDate date];
    } errorBlock:^(NSError *error) {
        self.stopsTimestamp = [NSDate date];
          if (errorBlock) {
            errorBlock(error);
        };
        [self handleError:error];
    }];
}

- (void)fetchAnnouncementsWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchAnnouncementsWithSuccessBlock:^(NSArray *announcements) {
        [self persistArray:announcements withFileName:kAnnouncementsFile];
        self.announcements = announcements;
        self.announcementsTimestamp = [NSDate date];
    } errorBlock:^(NSError *error) {
        self.announcementsTimestamp = [NSDate date];
          if (errorBlock) {
            errorBlock(error);
        };
        [self handleError:error];
    }];
}

#pragma mark -

- (NSArray *)stopsBeingServicedInArray:(NSArray *)stops {
    if ([self arrivals] == nil) {
        NSLog(@"No arrivals have been pulled yet.  Call -fetchArrivals before calling this method again.");
        return nil;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Stop *stop in stops) {
        for (Arrival *arrival in self.arrivals) {
            for (ArrivalStop *arrivalStop in arrival.stops) {
                if ([arrivalStop.name isEqualToString:stop.uniqueName] && ![mutableArray containsObject:stop]) {
                    [mutableArray addObject:stop];
                }
            }
        }
    }
    
    return mutableArray;
}

- (NSArray *)arrivalsContainingStopName:(NSString *)name {
    if ([self arrivals] == nil) {
        NSLog(@"No arrivals have been pulled yet.  Call -fetchArrivals before calling this method again.");
        return nil;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Arrival *arrival in self.arrivals) {
        for (ArrivalStop *stop in arrival.stops) {
            if ([stop.name isEqualToString:name]) {
                [mutableArray addObject:arrival];
            }
        }
    }
    
    return mutableArray;
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

- (Arrival *)arrivalForID:(NSString *)arrivalID {
    return [self.arrivalsDictionary objectForKey:arrivalID];
}

@end
