//
//  DistanceTagView.m
//  MBus
//
//  Created by Jonah Grant on 2/24/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "DistanceTagView.h"
#import "UMAdditions+UIFont.h"

static CGFloat kOriginX = 80.0f;
static CGFloat kHeight = 13;
static CGFloat kSidePadding = 8;

@implementation DistanceTagView

void drawDistanceTagView(CGContextRef context, CGFloat y, NSString *distanceAway) {
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont helveticaNeueWithWeight:TypeWeightNormal size:11.0f],
                                     NSForegroundColorAttributeName: [UIColor colorWithRed:0.596078 green:0.596078 blue:0.596078 alpha:1.0000]};
    
    CGFloat width = [distanceAway.uppercaseString boundingRectWithSize:CGSizeMake(MAXFLOAT, kHeight)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:textAttributes
                                                               context:nil].size.width;
    
    CGRect rect = CGRectMake(kOriginX, y, width + kSidePadding, kHeight);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(2, 2)];
    path.lineWidth = 0.5f;
    [[UIColor colorWithRed:0.886275 green:0.886275 blue:0.886275 alpha:1.0000] setStroke];
    [path stroke];
    [[UIColor clearColor] setFill];
    [path fill];
    [path addClip];
    
    [distanceAway.uppercaseString drawInRect:CGRectMake(rect.origin.x + (kSidePadding / 2.0f), rect.origin.y, width + kSidePadding, CGRectGetHeight(rect))
                              withAttributes:textAttributes];
}


@end
