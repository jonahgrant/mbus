//
//  StopCellModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stop;

@interface StopCellModel : NSObject

@property (strong, nonatomic) Stop *stop;
@property (nonatomic, copy) NSString *distance;

- (instancetype)initWithStop:(Stop *)stop;

@end
