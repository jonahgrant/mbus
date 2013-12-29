//
//  StopViewControllerTitleView.m
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopViewControllerTitleView.h"
#import "StopViewControllerTitleViewModel.h"
#import "Stop.h"
#import "DataStore.h"
#import "MarqueeLabel.h"

@implementation StopViewControllerTitleView

- (instancetype)initWithStop:(Stop *)stop {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        self.model = [[StopViewControllerTitleViewModel alloc] initWithStop:stop];
        self.opaque = YES;
        
        MarqueeLabel *stopLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 5, 180, 22) rate:80.0 andFadeLength:10.0f];
        stopLabel.tapToScroll = YES;
        stopLabel.backgroundColor = [UIColor clearColor];
        stopLabel.numberOfLines = 1;
        stopLabel.font = [UIFont boldSystemFontOfSize:17];
        stopLabel.textAlignment = NSTextAlignmentCenter;
        stopLabel.textColor = [UIColor blackColor];
        stopLabel.text = self.model.stop.humanName;
        [self addSubview:stopLabel];
        
        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, 180, 22)];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.numberOfLines = 1;
        distanceLabel.font = [UIFont systemFontOfSize:14];
        distanceLabel.textAlignment = NSTextAlignmentCenter;
        distanceLabel.textColor = [UIColor grayColor];
        distanceLabel.text = [[self.model distance] stringByAppendingString:@" away"];
        [self addSubview:distanceLabel];
        
        [RACObserve([DataStore sharedManager], lastKnownLocation) subscribeNext:^(CLLocation *location) {
            distanceLabel.text = [[self.model distance] stringByAppendingString:@" away"];
        }];
    }
    return self;
}

@end
