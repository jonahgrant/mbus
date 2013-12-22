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
static NSString * kArrivalsDictionaryFile = @"arrivalsdictionary.txt";
static NSString * kTraceRoutesFile = @"traceroutes.txt";
static NSString * kPlacemarksFile = @"placemarks.txt";

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
                [self persistObject:@[location] withFileName:kLastKnownLocation];
            }
        }];
    }
    return self;
}

- (void)handleError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)persistObject:(id)object withFileName:(NSString *)fileName {
    [[NSKeyedArchiver archivedDataWithRootObject:object] writeToFile:[self filePathWithName:fileName] atomically:YES];
}

- (NSString *)filePathWithName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (id)persistedObjectWithFileName:(NSString *)fileName {
    NSData *data = [NSData dataWithContentsOfFile:[self filePathWithName:fileName]];
    if (!data) {
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma Properties

- (NSArray *)persistedArrivals {
    return [self persistedObjectWithFileName:kArrivalsFile];
}

- (NSDictionary *)persistedArrivalsDictionary {
    return [self persistedObjectWithFileName:kArrivalsDictionaryFile];
}

- (NSArray *)persistedBuses {
    return [self persistedObjectWithFileName:kBusesFile];
}

- (NSArray *)persistedStops {
    return [self persistedObjectWithFileName:kStopsFile];
}

- (NSArray *)persistedAnnouncements {
    return [self persistedObjectWithFileName:kAnnouncementsFile];
}

- (NSDictionary *)persistedTraceRoutes {
    return [self persistedObjectWithFileName:kTraceRoutesFile];
}

- (NSDictionary *)persistedPlacemarks {
    return [self persistedObjectWithFileName:kPlacemarksFile];
}

- (CLLocation *)persistedLastKnownLocation {
    return [self persistedObjectWithFileName:kLastKnownLocation][0];
}

#pragma Persisting

- (void)persistTraceRoute:(NSArray *)traceRoute forRouteID:(NSString *)routeID {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:self.persistedTraceRoutes];
    [mutableDictionary addEntriesFromDictionary:@{routeID: traceRoute}];
    [self persistObject:mutableDictionary withFileName:kTraceRoutesFile];
}

- (void)persistPlacemark:(CLPlacemark *)placemark forStopID:(NSString *)stopID {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:self.persistedPlacemarks];
    [mutableDictionary addEntriesFromDictionary:@{stopID: placemark}];
    [self persistObject:mutableDictionary withFileName:kPlacemarksFile];
}

#pragma Fetch

- (void)fetchArrivalsWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchArrivalsWithSuccessBlock:^(NSArray *arrivals) {
        self.arrivalsTimestamp = [NSDate date];
        [self persistObject:arrivals withFileName:kArrivalsFile];
        self.arrivals = arrivals;
        
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        for (Arrival *arrival in arrivals) {
            [mutableDictionary addEntriesFromDictionary:@{arrival.id: arrival}];
        }
        self.arrivalsDictionary = mutableDictionary;
        [self persistObject:mutableDictionary withFileName:kArrivalsDictionaryFile];
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
        self.busesTimestamp = [NSDate date];
        [self persistObject:buses withFileName:kBusesFile];
        self.buses = buses;
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
        self.stopsTimestamp = [NSDate date];
        [self persistObject:stops withFileName:kStopsFile];
        self.stops = stops;
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
        self.announcementsTimestamp = [NSDate date];
        [self persistObject:announcements withFileName:kAnnouncementsFile];
        self.announcements = announcements;
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
    return [self.persistedArrivalsDictionary objectForKey:arrivalID];
}

- (BOOL)hasTraceRouteForRouteID:(NSString *)routeID {
    if ([self.persistedTraceRoutes objectForKey:routeID]) {
        return YES;
    }
    
    return NO;
}

- (NSArray *)traceRouteForRouteID:(NSString *)routeID {
    return [self.persistedTraceRoutes objectForKey:routeID];
}

- (BOOL)hasPlacemarkForStopID:(NSString *)stopID {
    if ([self.persistedPlacemarks objectForKey:stopID]) {
        return YES;
    }
    
    return NO;
}

- (CLPlacemark *)placemarkForStopID:(NSString *)stopID {
    return [self.persistedPlacemarks objectForKey:stopID];
}

@end
