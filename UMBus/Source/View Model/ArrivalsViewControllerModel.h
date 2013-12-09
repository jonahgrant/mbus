//
//  ArrivalsViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Arrival;

@interface ArrivalsViewControllerModel : NSObject

@property (strong, nonatomic) Arrival *arrival;

- (instancetype)initWithArrival:(Arrival *)arrival;

- (NSArray *)stopsOrderedByTimeOfArrivalWithStops:(NSArray *)stops;

- (NSString *)mmssForTimeInterval:(NSTimeInterval)timeInterval;

@end
