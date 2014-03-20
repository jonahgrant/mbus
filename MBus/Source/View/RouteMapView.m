//
//  RouteMapView.m
//  MBus
//
//  Created by Jonah Grant on 3/16/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "RouteMapView.h"
#import "UMAdditions+UIFont.h"

@implementation RouteMapView

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
              backgroundColor:(UIColor *)backgroundColor
                    textColor:(UIColor *)textColor
                        frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = backgroundColor;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), 44)];
        titleLabel.text = title;
        titleLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightBold size:16];
        titleLabel.textColor = textColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(frame), 44)];
        subtitleLabel.text = subtitle;
        subtitleLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightNormal size:13];
        subtitleLabel.textColor = textColor;
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:subtitleLabel];
    }
    return self;
}

@end
