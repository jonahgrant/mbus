//
//  DataStore.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void (^DataStoreErrorBlock)(NSError *error);

@class Arrival, Bus, Route, ArrivalStop;

@interface DataStore : NSObject

@property (strong, nonatomic) NSArray *arrivals, *buses, *stops, *announcements;
@property (strong, nonatomic) NSDate *arrivalsTimestamp, *busesTimestamp, *stopsTimestamp, *announcementsTimestamp;

@property (strong, nonatomic) CLLocation *lastKnownLocation;

+ (instancetype)sharedManager;

- (void)fetchArrivalsWithErrorBlock:(DataStoreErrorBlock)errorBlock;
- (void)fetchBusesWithErrorBlock:(DataStoreErrorBlock)errorBlock;
- (void)fetchStopsWithErrorBlock:(DataStoreErrorBlock)errorBlock;
- (void)fetchAnnouncementsWithErrorBlock:(DataStoreErrorBlock)errorBlock;

- (NSArray *)persistedArrivals;
- (NSArray *)persistedBuses;
- (NSArray *)persistedStops;
- (NSArray *)persistedAnnouncements;
- (NSDictionary *)persistedTraceRoutes;
- (CLLocation *)persistedLastKnownLocation;

- (void)persistTraceRoute:(NSArray *)traceRoute forRouteID:(NSString *)routeID;
- (BOOL)hasTraceRouteForRouteID:(NSString *)routeID;
- (NSArray *)traceRouteForRouteID:(NSString *)routeID;

/*
 Takes in an array of Stop objects and returns the ones that are being serviced
 Requires self.arrivals to be loaded
 */
- (NSArray *)stopsBeingServicedInArray:(NSArray *)array;

/*
 Returns arrivals containing a stop name.  Used to determine what routes are servicing a given stop
 */
- (NSArray *)arrivalsContainingStopName:(NSString *)name;

// TODO: DOCUMENT THE BELOW METHODS ***************************

- (ArrivalStop *)arrivalStopForRouteID:(NSString *)routeID stopName:(NSString *)stopName;

- (BOOL)arrivalHasBus1WithArrivalID:(NSString *)arrivalID;
- (BOOL)arrivalHasBus2WithArrivalID:(NSString *)arrivalID;

- (Arrival *)arrivalForID:(NSString *)arrivalID;

@end
