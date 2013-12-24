//
//  RouteViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Arrival;

@interface RouteViewControllerModel : NSObject

@property (strong, nonatomic) Arrival *arrival;
@property (strong, nonatomic) NSArray *sortedStops;

- (instancetype)initWithArrival:(Arrival *)arrival;

- (NSArray *)stopsOrderedByTimeOfArrivalWithStops:(NSArray *)stops;
- (NSString *)mmssForTimeInterval:(NSTimeInterval)timeInterval;
- (NSString *)footerString;

@end
