//
//  StopViewControllerTitleViewModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@class Stop;

@interface StopViewControllerTitleViewModel : NSObject

@property (strong, nonatomic) Stop *stop;

- (instancetype)initWithStop:(Stop *)stop;

- (NSString *)distance;

@end
