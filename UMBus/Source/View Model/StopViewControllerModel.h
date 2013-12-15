//
//  StopViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stop;

@interface StopViewControllerModel : NSObject

@property (strong, nonatomic) Stop *stop;
@property (strong, nonatomic) NSArray *arrivals;

- (instancetype)initWithStop:(Stop *)stop;

@end
