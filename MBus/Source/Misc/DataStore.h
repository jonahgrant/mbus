//
//  DataStore.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@import CoreLocation;

typedef void (^DataStoreErrorBlock)(NSError *error);

@class Arrival, Bus, Route, ArrivalStop, Stop;

@interface DataStore : NSObject

@property (strong, nonatomic, readonly) NSArray *arrivals, *buses, *stops, *announcements;
@property (strong, nonatomic, readonly) NSDate *arrivalsTimestamp, *busesTimestamp, *stopsTimestamp, *announcementsTimestamp;
@property (strong, nonatomic, readonly) CLLocation *lastKnownLocation;

+ (instancetype)sharedManager;

- (void)fetchArrivalsWithErrorBlock:(DataStoreErrorBlock)errorBlock requester:(id)requester;
- (void)fetchBusesWithErrorBlock:(DataStoreErrorBlock)errorBlock requester:(id)requester;
- (void)fetchStopsWithErrorBlock:(DataStoreErrorBlock)errorBlock requester:(id)requester;
- (void)fetchAnnouncementsWithErrorBlock:(DataStoreErrorBlock)errorBlock requester:(id)requester;

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

- (void)setColorsForStopWithUniqueName:(NSString *)uniqueName colors:(NSArray *)colors;
- (NSArray *)fetchColorsForStopWithUniqueName:(NSString *)uniqueName;

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

- (Stop *)stopForArrivalStopName:(NSString *)name;

@end
