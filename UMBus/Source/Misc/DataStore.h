//
//  DataStore.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Arrival, ArrivalStop, Bus;

@interface DataStore : NSObject

@property (strong, nonatomic, readonly) NSArray *arrivals, *buses, *stops;
@property (strong, nonatomic, readonly) NSDictionary *arrivalsDictionary, *busesForRoutesDictionary;

+ (instancetype)sharedManager;

- (void)fetchArrivals;
- (void)fetchBuses;
- (void)fetchStops;

- (Arrival *)arrivalForID:(NSString *)arrivalID;
- (Bus *)busOperatingRouteID:(NSString *)routeID;

- (NSArray *)arrivalStopsForStopID:(NSString *)stopID;
- (NSArray *)allArrivalStops;

@end
