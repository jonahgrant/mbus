//
//  ArrivalCellModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArrivalStop, Arrival;

@interface ArrivalCellModel : NSObject

@property (strong, nonatomic) ArrivalStop *stop;
@property (strong, nonatomic) Arrival *arrival;

- (instancetype)initWithStop:(ArrivalStop *)stop forArrival:(Arrival *)arrival;

- (NSString *)abbreviatedArrivalTimeForTimeInterval:(NSTimeInterval)timeInterval;
- (NSString *)timeOfArrivalForTimeInterval:(NSTimeInterval)interval;

@end
