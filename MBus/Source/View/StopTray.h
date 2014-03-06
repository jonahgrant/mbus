//
//  StopTray.h
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@class StopTrayModel, Stop, StopAnnotation;

@interface StopTray : UIToolbar

@property (strong, nonatomic) StopTrayModel *model;
@property (nonatomic) id target;

- (instancetype)initWithTintColor:(UIColor *)color;

@end
