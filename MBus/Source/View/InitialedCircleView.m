//
//  InitialedCircleView.m
//  MBus
//
//  Created by Jonah Grant on 2/24/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "InitialedCircleView.h"
#import "UMAdditions+UIFont.h"

@implementation InitialedCircleView

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor, NSString *initials) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {
        0.0, 1.0
    };
    
    NSArray *colors = [NSArray array];
    
    if (startColor && endColor) {
        colors = @[(__bridge id)startColor, (__bridge id)endColor];
    } else if (startColor && !endColor) {
        colors = @[(__bridge id)startColor];
    } else if (!startColor && endColor) {
        colors = @[(__bridge id)endColor];
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    
    const CGFloat *componentColors = CGColorGetComponents(startColor);
    
    CGFloat darknessScore = (((componentColors[0] * 255) * 299) + ((componentColors[1] * 255) * 587) + ((componentColors[2] * 255) * 114)) / 1000;
    
    [initials drawInRect:CGRectMake(rect.origin.x, CGRectGetHeight(rect) / 1.8, CGRectGetWidth(rect), CGRectGetHeight(rect))
          withAttributes:@{ NSFontAttributeName: [UIFont helveticaNeueWithWeight:TypeWeightLight size:18.0f],
                            NSForegroundColorAttributeName: (darknessScore >= 215) ? [UIColor blackColor] : [UIColor whiteColor],
                            NSParagraphStyleAttributeName: style}];
}


@end
