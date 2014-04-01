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
#import "UMAdditions+UIColor.h"
#import "Constants.h"

static NSString * const kLastKnownLocation      = @"lastKnownLocation.txt";
static NSString * const kStopsFile              = @"stops.txt";
static NSString * const kBusesFile              = @"buses.txt";
static NSString * const kAnnouncementsFile      = @"announcements.txt";
static NSString * const kArrivalsFile           = @"arrivals.txt";
static NSString * const kArrivalsDictionaryFile = @"arrivalsdictionary.txt";
static NSString * const kTraceRoutesFile        = @"traceroutes.txt";
static NSString * const kPlacemarksFile         = @"placemarks.txt";

@interface DataStore ()

// private properties
@property (strong, nonatomic, readwrite) UMNetworkingSession *networkingSession;
@property (strong, nonatomic, readwrite) NSDictionary *arrivalsDictionary;
@property (strong, nonatomic, readwrite) NSMutableDictionary *stopColorsDictionary;
@property (strong, nonatomic, readwrite) NSArray *localPersistedArrivals, *localPersistedBuses, *localPersistedStops, *localPersistedAnnouncements;
@property (strong, nonatomic, readwrite) NSDictionary *localPersistedTraceRoutes, *localPersistedPlacemarks, *localPersistedArrivalsDictionary;
@property (strong, nonatomic, readwrite) CLLocation *localPersistedLastKnownLocation;

// public properties
@property (strong, nonatomic, readwrite) NSArray *arrivals, *buses, *stops, *announcements;
@property (strong, nonatomic, readwrite) NSDate *arrivalsTimestamp, *busesTimestamp, *stopsTimestamp, *announcementsTimestamp;
@property (strong, nonatomic, readwrite) CLLocation *lastKnownLocation;

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
        
        self.stopColorsDictionary = [NSMutableDictionary dictionary];
        
        [self fetchPersistedObjects];
        
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
    SendError([self class], error.localizedDescription);
}

- (void)persistObject:(id)object withFileName:(NSString *)fileName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[NSKeyedArchiver archivedDataWithRootObject:object] writeToFile:[self filePathWithName:fileName] atomically:YES];
    });
}

- (NSString *)filePathWithName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (id)persistedObjectWithFileName:(NSString *)fileName {
    __block id returnedData = nil;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^ {
        NSData *localData = [NSData dataWithContentsOfFile:[self filePathWithName:fileName]];
        returnedData = (!localData) ? nil : [NSKeyedUnarchiver unarchiveObjectWithData:localData];
    });
    
    return returnedData;
}

- (void)fetchPersistedObjects {
    self.localPersistedArrivals             = [self persistedObjectWithFileName:kArrivalsFile];
    self.localPersistedArrivalsDictionary   = [self persistedObjectWithFileName:kArrivalsDictionaryFile];
    self.localPersistedBuses                = [self persistedObjectWithFileName:kBusesFile];
    self.localPersistedStops                = [self persistedObjectWithFileName:kStopsFile];
    self.localPersistedAnnouncements        = [self persistedObjectWithFileName:kAnnouncementsFile];
    self.localPersistedPlacemarks           = [self persistedObjectWithFileName:kPlacemarksFile];
    self.localPersistedLastKnownLocation    = [self persistedObjectWithFileName:kLastKnownLocation][0];
    
    [self fetchPersistedTraceRoutes];
}

- (void)fetchPersistedTraceRoutes {
    self.localPersistedTraceRoutes = [self persistedObjectWithFileName:kTraceRoutesFile];
}

#pragma Properties

- (NSArray *)persistedArrivals {
    return self.localPersistedArrivals;
}

- (NSDictionary *)persistedArrivalsDictionary {
    return self.localPersistedArrivalsDictionary;
}

- (NSArray *)persistedBuses {
    return self.localPersistedBuses;
}

- (NSArray *)persistedStops {
    return self.localPersistedStops;
}

- (NSArray *)persistedAnnouncements {
    return self.localPersistedAnnouncements;
}

- (NSDictionary *)persistedTraceRoutes {
    return self.localPersistedTraceRoutes;
}

- (NSDictionary *)persistedPlacemarks {
    return self.localPersistedPlacemarks;
}

- (CLLocation *)persistedLastKnownLocation {
    return self.localPersistedLastKnownLocation;
}

#pragma Persisting

- (void)persistTraceRoute:(NSArray *)traceRoute forRouteID:(NSString *)routeID {
    if (traceRoute && routeID) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:self.persistedTraceRoutes];
        [mutableDictionary addEntriesFromDictionary:@{routeID: traceRoute}];
        [self persistObject:mutableDictionary withFileName:kTraceRoutesFile];
        
        [self fetchPersistedTraceRoutes];
    }
}

- (void)persistPlacemark:(CLPlacemark *)placemark forStopID:(NSString *)stopID {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:self.persistedPlacemarks];
    [mutableDictionary addEntriesFromDictionary:@{stopID: placemark}];
    [self persistObject:mutableDictionary withFileName:kPlacemarksFile];

    NSMutableDictionary *localMutableDictionary = [NSMutableDictionary dictionaryWithDictionary:self.persistedPlacemarks];
    [localMutableDictionary addEntriesFromDictionary:@{stopID: placemark}];
    self.localPersistedPlacemarks = localMutableDictionary;
}

#pragma Fetch

- (void)fetchArrivalsWithErrorBlock:(DataStoreErrorBlock)errorBlock requester:(id)requester {
    SendEventWithLabel(ANALYTICS_FETCH_ARRIVALS, NSStringFromClass([requester class]));
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

- (void)fetchBusesWithErrorBlock:(DataStoreErrorBlock)errorBlock requester:(id)requester {
    SendEventWithLabel(ANALYTICS_FETCH_BUSES, NSStringFromClass([requester class]));
    SendEvent(ANALYTICS_FETCH_BUSES);
    [self.networkingSession fetchBusesWithSuccessBlock:^(NSArray *buses) {
        self.busesTimestamp = [NSDate date];
        self.buses = buses;

        [self persistObject:buses withFileName:kBusesFile];
    } errorBlock:^(NSError *error) {
        self.busesTimestamp = [NSDate date];
        
        if (errorBlock) {
            errorBlock(error);
        }
                
        [self handleError:error];
    }];
}

- (void)fetchStopsWithErrorBlock:(DataStoreErrorBlock)errorBlock requester:(id)requester {
    SendEventWithLabel(ANALYTICS_FETCH_STOPS, NSStringFromClass([requester class]));
    [self.networkingSession fetchStopsWithSuccessBlock:^(NSArray *stops) {
        self.stopsTimestamp = [NSDate date];
        
        for (Stop *stop in stops) {
            [self setColorsForStopWithUniqueName:stop.uniqueName
                                          colors:[UIColor gradientForStyle:arc4random_uniform(16)]];
        }
        
        self.stops = stops;
        [self persistObject:stops withFileName:kStopsFile];
    } errorBlock:^(NSError *error) {
        self.stopsTimestamp = [NSDate date];
        
        if (errorBlock) {
            errorBlock(error);
        }
        
        [self handleError:error];
    }];
}

- (void)fetchAnnouncementsWithErrorBlock:(DataStoreErrorBlock)errorBlock requester:(id)requester {
    SendEventWithLabel(ANALYTICS_FETCH_ANNOUNCEMENTS, NSStringFromClass([requester class]));
    [self.networkingSession fetchAnnouncementsWithSuccessBlock:^(NSArray *announcements) {
        self.announcementsTimestamp = [NSDate date];
        self.announcements = announcements;
        [self persistObject:announcements withFileName:kAnnouncementsFile];
    } errorBlock:^(NSError *error) {
        self.announcementsTimestamp = [NSDate date];
        
        if (errorBlock) {
            errorBlock(error);
        }
        
        [self handleError:error];
    }];
}

#pragma mark -

- (NSArray *)stopsBeingServicedInArray:(NSArray *)stops {
    if ([self arrivals] == nil) {
        return nil;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Stop *stop in stops) {
        for (Arrival *arrival in self.arrivals) {
            for (ArrivalStop *arrivalStop in arrival.stops) {
                if ([arrivalStop.name isEqualToString:stop.uniqueName] && ![mutableArray containsObject:stop]) {
                    [mutableArray push:stop];
                }
            }
        }
    }
    
    return mutableArray;
}

- (NSArray *)arrivalsContainingStopName:(NSString *)name {
    if ([self arrivals] == nil) {
        return nil;
    }
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (Arrival *arrival in self.arrivals) {
        for (ArrivalStop *stop in arrival.stops) {
            if ([stop.name isEqualToString:name]) {
                [mutableArray push:arrival];
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
    for (ArrivalStop *stop in arrival.stops) {
        if (stop.timeOfArrival > 0) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)arrivalHasBus2WithArrivalID:(NSString *)arrivalID {
    Arrival *arrival = [self arrivalForID:arrivalID];
    for (ArrivalStop *stop in arrival.stops) {
        if (stop.timeOfArrival2 > 0) {
            return YES;
        }
    }
    
    return NO;
}

- (Arrival *)arrivalForID:(NSString *)arrivalID {
    return self.arrivalsDictionary[arrivalID];
}

- (BOOL)hasTraceRouteForRouteID:(NSString *)routeID {
    return (self.persistedTraceRoutes[routeID] != nil);
}

- (NSArray *)traceRouteForRouteID:(NSString *)routeID {
    return self.persistedTraceRoutes[routeID];
}

- (BOOL)hasPlacemarkForStopID:(NSString *)stopID {
    return (self.persistedPlacemarks[stopID] != nil);
}

- (CLPlacemark *)placemarkForStopID:(NSString *)stopID {
    return self.persistedPlacemarks[stopID];
}

- (void)setColorsForStopWithUniqueName:(NSString *)uniqueName colors:(NSArray *)colors {
    if (![self fetchColorsForStopWithUniqueName:uniqueName]) {
        [self.stopColorsDictionary addEntriesFromDictionary:@{uniqueName: colors}];
    }
}

- (NSArray *)fetchColorsForStopWithUniqueName:(NSString *)uniqueName {
    return self.stopColorsDictionary[uniqueName];
}

- (Stop *)stopForArrivalStopName:(NSString *)name {
    for (Stop *stop in self.stops) {
        if ([stop.uniqueName isEqualToString:name]) {
            return stop;
        }
    }
    
    return nil;
}

@end
