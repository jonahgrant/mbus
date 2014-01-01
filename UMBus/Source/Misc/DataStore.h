//
//  DataStore.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@import CoreLocation;

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
- (NSDictionary *)persistedPlacemarks;
- (NSDictionary *)persistedArrivalsDictionary;
- (CLLocation *)persistedLastKnownLocation;

- (void)persistTraceRoute:(NSArray *)traceRoute forRouteID:(NSString *)routeID;
- (BOOL)hasTraceRouteForRouteID:(NSString *)routeID;
- (NSArray *)traceRouteForRouteID:(NSString *)routeID;

- (void)persistPlacemark:(CLPlacemark *)placemark forStopID:(NSString *)stopID;
- (BOOL)hasPlacemarkForStopID:(NSString *)stopID;
- (CLPlacemark *)placemarkForStopID:(NSString *)stopID;

/*
 Takes in an array of Stop objects and returns the ones that are being serviced
 Requires self.arrivals to be loaded
 */
- (NSArray *)stopsBeingServicedInArray:(NSArray *)array;

/*
 Returns arrivals containing a stop name.  Used to determine what routes are servicing a given stop
 */
- (NSArray *)arrivalsContainingStopName:(NSString *)name;

/*
 Searches through all ArrivalStop objects to find the one that matches a given stop name on a given route
 */
- (ArrivalStop *)arrivalStopForRouteID:(NSString *)routeID stopName:(NSString *)stopName;

/*
 Returns TRUE if an Arrival object has a "bus1" servicing it.  This is determined by the Magic Bus API
 */
- (BOOL)arrivalHasBus1WithArrivalID:(NSString *)arrivalID;

/*
 Returns TRUE if an Arrival object has a "bus2" servicing it.  This is determined by the Magic Bus API
 */
- (BOOL)arrivalHasBus2WithArrivalID:(NSString *)arrivalID;

/*
 Takes an arrival id and returns it's Arrival object
 */
- (Arrival *)arrivalForID:(NSString *)arrivalID;

@end
