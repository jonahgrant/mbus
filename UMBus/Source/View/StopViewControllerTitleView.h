//
//  StopViewControllerTitleView.h
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@class StopViewControllerTitleViewModel, Stop;

@interface StopViewControllerTitleView : UIView

@property (strong, nonatomic) StopViewControllerTitleViewModel *model;

- (instancetype)initWithStop:(Stop *)stop;

@end
