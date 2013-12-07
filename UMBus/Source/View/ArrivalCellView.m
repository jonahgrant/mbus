//
//  ArrivalCellView.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalCellView.h"
#import "ArrivalCellModel.h"
#import "Arrival.h"
#import "HexColor.h"

@implementation ArrivalCellView

- (instancetype)initWithFrame:(CGRect)frame arrivalModel:(ArrivalCellModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.backgroundColor = [UIColor clearColor];
        
        [RACObserve(self, model) subscribeNext:^(id x) {
            [self setNeedsDisplay];
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat initialXValue = 10;

    NSString *routeName = self.model.arrival.name;
    UIColor *busRouteColor = [UIColor colorWithHexString:self.model.arrival.busRouteColor];
    
    NSDictionary *routeNameDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:14.0f],
                                           NSForegroundColorAttributeName: [UIColor blackColor]};
    CGRect routeNameRect = CGRectMake(50, initialXValue, rect.size.width - 50, [routeName boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                                                    attributes:routeNameDictionary
                                                                                                       context:nil].size.height);
    
    CGContextSetFillColorWithColor(context, busRouteColor.CGColor);
    CGRect circlePoint = CGRectMake(10, 10, 20, 20);
    CGContextFillEllipseInRect(context, circlePoint);
    
    [self.model.arrival.name drawInRect:routeNameRect
                         withAttributes:routeNameDictionary];
    
    // Divider line
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.882855 green:0.882855 blue:0.882855 alpha:1.0000].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.bounds.origin.x + 20, self.bounds.size.height / 2);
    CGContextAddLineToPoint(context, self.bounds.size.width - 30, self.bounds.size.height / 2);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    CGContextSetRGBFillColor(context, 0,0,0,0.75);
    
    // Vertical divider line
    [[UIColor brownColor] set];
    /* Get the current graphics context */
    CGContextRef currentContext =UIGraphicsGetCurrentContext();
    /* Set the width for the line */
    CGContextSetLineWidth(currentContext,5.0f);
    /* Start the line at this point */
    CGContextMoveToPoint(currentContext,50.0f, 10.0f);
    /* And end it at this point */
    CGContextAddLineToPoint(currentContext,100.0f, 200.0f);
    /* Use the context's current color to draw the line */
    CGContextStrokePath(currentContext);
}

@end
