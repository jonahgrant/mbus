//
//  ArrivalCellModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Arrival;

@interface ArrivalCellModel : NSObject

@property (strong, nonatomic) Arrival *arrival;

- (instancetype)initWithArrival:(Arrival *)arrival;

@end
