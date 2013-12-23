//
//  StopArrivalCellModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Arrival, Stop;

@interface StopArrivalCellModel : NSObject

@property (strong, nonatomic) Arrival *arrival;
@property (strong, nonatomic) Stop *stop;
@property (nonatomic) NSTimeInterval firstArrival;
@property (nonatomic, copy) NSString *firstArrivalSuffix, *firstArrivalString;

- (instancetype)initWithArrival:(Arrival *)arrival stop:(Stop *)stop;

@end
