//
//  CircleAnnotationView.m
//  UMBus
//
//  Created by Jonah Grant on 12/8/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "CircleAnnotationView.h"

@interface CircleAnnotationView ()

@property (strong, nonatomic) UIColor *color, *outlineColor;

@end

@implementation CircleAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                             color:(UIColor *)color
                      outlineColor:(UIColor *)outlineColor {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 28, 28);
        self.opaque = NO;
        self.color = color;
        self.outlineColor = outlineColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0f);
    
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGRect circlePoint = CGRectMake(rect.origin.x + 5, rect.origin.y + 5, 20, 20);
    CGContextFillEllipseInRect(context, circlePoint);
    CGContextSetStrokeColorWithColor(context, self.outlineColor.CGColor);
    CGContextStrokeEllipseInRect(context, circlePoint);
}

@end
