//
//  ArrivalRouteCellView.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalRouteCellView.h"
#import "ArrivalRouteCellModel.h"
#import "Arrival.h"
#import "HexColor.h"

@implementation ArrivalRouteCellView

- (instancetype)initWithFrame:(CGRect)frame arrivalModel:(ArrivalRouteCellModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
        
        [RACObserve(self, model) subscribeNext:^(id x) {
            [self setNeedsDisplay];
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x = rect.size.height / 2;
    
    NSString *routeName = self.model.arrival.name;
    UIColor *busRouteColor = [UIColor colorWithHexString:self.model.arrival.busRouteColor];
    
    NSDictionary *routeNameDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17],
                                           NSForegroundColorAttributeName: [UIColor blackColor]};
    CGFloat routeNameHeight = [routeName boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:routeNameDictionary
                                                      context:nil].size.height;
    CGRect routeNameRect = CGRectMake(40, x - (routeNameHeight / 2), rect.size.width - 50, routeNameHeight);

    CGContextSetFillColorWithColor(context, busRouteColor.CGColor);
    CGRect circlePoint = CGRectMake(10, x - 10, 20, 20);
    CGContextFillEllipseInRect(context, circlePoint);
    
    [routeName drawInRect:routeNameRect withAttributes:routeNameDictionary];
    
    // Divider line
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.882855 green:0.882855 blue:0.882855 alpha:1.0000].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.bounds.origin.x, rect.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, rect.size.height);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    CGContextSetRGBFillColor(context, 0,0,0,0.75);
}

@end
