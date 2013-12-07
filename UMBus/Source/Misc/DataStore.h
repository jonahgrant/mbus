//
//  DataStore.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Arrival, ArrivalStop;

@interface DataStore : NSObject

@property (strong, nonatomic, readonly) NSArray *arrivals;

+ (instancetype)sharedManager;

- (void)fetchArrivals;

- (Arrival *)arrivalForID:(NSString *)arrivalID;
- (NSArray *)arrivalStopsForStopID:(NSString *)stopID;
- (NSArray *)allArrivalStops;

@end
