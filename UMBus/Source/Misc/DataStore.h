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
- (CLLocation *)persistedLastKnownLocation;

@end
