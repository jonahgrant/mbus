//
//  DataStore.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Arrival, Bus;

@interface DataStore : NSObject

@property (strong, nonatomic, readonly) NSArray *arrivals, *buses, *stops, *announcements;
@property (strong, nonatomic, readonly) NSDictionary *arrivalsDictionary, *busesForRoutesDictionary;

+ (instancetype)sharedManager;

- (void)fetchArrivals;
- (void)fetchBuses;
- (void)fetchStops;
- (void)fetchAnnouncements;

- (Arrival *)arrivalForID:(NSString *)arrivalID;
- (Bus *)busOperatingRouteID:(NSString *)routeID;

- (NSArray *)arrivalStopsForStopID:(NSString *)stopID;
- (NSArray *)allArrivalStops;

@end
