//
//  RouteMapView.h
//  MBus
//
//  Created by Jonah Grant on 3/16/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteMapView : UIView

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
              backgroundColor:(UIColor *)backgroundColor
                    textColor:(UIColor *)textColor
                        frame:(CGRect)frame;

@end
