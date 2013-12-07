//
//  ArrivalCellView.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalCellView.h"
#import "ArrivalCellModel.h"
#import "ArrivalStop.h"
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
    
    CGFloat x = rect.size.height / 2;
    
    NSString *routeName = self.model.stop.name2;
    NSString *routeTimeOfArrival = [self.model abbreviatedArrivalTime];
    
    UIColor *busRouteColor = [UIColor colorWithRed:0.576660 green:0.576660 blue:0.576660 alpha:1.0000];
    
    NSDictionary *routeNameDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17],
                                           NSForegroundColorAttributeName: [UIColor blackColor]};
    
    NSDictionary *arrivalTimeDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:12],
                                             NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    CGFloat routeNameHeight = [routeName boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:routeNameDictionary
                                                      context:nil].size.height;
    
    CGRect circleRect = CGRectMake(10,
                                   x - 10,
                                   40,
                                   40);

    CGRect routeTimeOfArrivalRect = [routeTimeOfArrival boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:arrivalTimeDictionary
                                                                       context:nil];
    CGRect routeNameRect = CGRectMake(60,
                                      x,
                                      rect.size.width - 60,
                                      routeNameHeight);
    
    CGRect arrivalTimeRect = CGRectMake(circleRect.origin.x + ((circleRect.size.width - routeTimeOfArrivalRect.size.width) / 2),
                                        circleRect.origin.y + (circleRect.size.height - (routeTimeOfArrivalRect.size.height * 2)),
                                        routeTimeOfArrivalRect.size.width,
                                        routeTimeOfArrivalRect.size.height);
    
    // Stop name
    [routeName drawInRect:routeNameRect withAttributes:routeNameDictionary];

    // Vertical line
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.811630 green:0.811630 blue:0.811630 alpha:1.0000].CGColor);
    CGContextSetLineWidth(context, 10.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 30, 0);
    CGContextAddLineToPoint(context, 30, rect.size.height);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    CGContextSetRGBFillColor(context, 0,0,0,0.75);

    // Arrival time circle
    CGContextSetFillColorWithColor(context, busRouteColor.CGColor);
    CGContextFillEllipseInRect(context, circleRect);
    
    [routeTimeOfArrival drawInRect:arrivalTimeRect withAttributes:arrivalTimeDictionary];
}


@end
