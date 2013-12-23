//
//  StopViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stop, Arrival;

@interface StopViewControllerModel : NSObject

@property (strong, nonatomic) Stop *stop;
@property (strong, nonatomic) NSArray *arrivalsServicingStop, *arrivalsServicingStopCellModels;

- (instancetype)initWithStop:(Stop *)stop;

- (void)fetchData;

- (NSDate *)firstArrivalDateForArrival:(Arrival *)arrival;
- (NSString *)timeSinceRoutesRefresh;

@end
