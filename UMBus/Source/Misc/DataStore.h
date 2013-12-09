//
//  DataStore.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataStoreErrorBlock)(NSError *error);

@class Arrival, Bus, Route;

@interface DataStore : NSObject

@property (strong, nonatomic, readonly) NSArray *arrivals, *buses, *stops, *announcements;
@property (strong, nonatomic, readonly) NSDictionary *arrivalsDictionary, *busesForRoutesDictionary;

+ (instancetype)sharedManager;

- (void)fetchArrivalsWithErrorBlock:(DataStoreErrorBlock)errorBlock;
- (void)fetchBusesWithErrorBlock:(DataStoreErrorBlock)errorBlock;
- (void)fetchStopsWithErrorBlock:(DataStoreErrorBlock)errorBlock;
- (void)fetchAnnouncementsWithErrorBlock:(DataStoreErrorBlock)errorBlock;

- (Arrival *)arrivalForID:(NSString *)arrivalID;
- (Bus *)busOperatingRouteID:(NSString *)routeID;

- (NSArray *)arrivalStopsForStopID:(NSString *)stopID;
- (NSArray *)allArrivalStops;

- (BOOL)arrivalHasBus1WithArrivalID:(NSString *)arrivalID;
- (BOOL)arrivalHasBus2WithArrivalID:(NSString *)arrivalID;

@end
