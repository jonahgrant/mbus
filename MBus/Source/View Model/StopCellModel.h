//
//  StopCellModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@class Stop;

@interface StopCellModel : NSObject

@property (strong, nonatomic, readonly) Stop *stop;
@property (nonatomic, copy, readonly) NSString *distance;
@property (nonatomic, strong, readonly) NSArray *circleColors;

- (instancetype)initWithStop:(Stop *)stop;

- (NSString *)initialsForStop:(NSString *)stopName;

@end
