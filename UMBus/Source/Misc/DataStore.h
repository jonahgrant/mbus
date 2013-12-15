//
//  DataStore.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataStoreErrorBlock)(NSError *error);

@class Arrival, Bus, Route, ArrivalStop;

@interface DataStore : NSObject

@property (strong, nonatomic) NSArray *arrivals, *buses, *stops, *announcements;
@property (strong, nonatomic) NSDictionary *arrivalsDictionary, *busesForRoutesDictionary;

+ (instancetype)sharedManager;

- (void)fetchArrivalsWithErrorBlock:(DataStoreErrorBlock)errorBlock;
- (void)fetchBusesWithErrorBlock:(DataStoreErrorBlock)errorBlock;
- (void)fetchStopsWithErrorBlock:(DataStoreErrorBlock)errorBlock;
- (void)fetchAnnouncementsWithErrorBlock:(DataStoreErrorBlock)errorBlock;

- (Arrival *)arrivalForID:(NSString *)arrivalID;
- (Bus *)busOperatingRouteID:(NSString *)routeID;
- (ArrivalStop *)arrivalStopForRouteID:(NSString *)routeID stopName:(NSString *)stopName;

- (NSArray *)arrivalStopsForStopID:(NSString *)stopID;
- (NSArray *)arrivalsContainingStopName:(NSString *)stopName;
- (NSArray *)allArrivalStops;

- (BOOL)arrivalHasBus1WithArrivalID:(NSString *)arrivalID;
- (BOOL)arrivalHasBus2WithArrivalID:(NSString *)arrivalID;

- (NSArray *)stopsBeingServiced;

@end
