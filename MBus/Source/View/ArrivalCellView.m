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
#import "Arrival.h"

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

- (void)drawRect:(CGRect)rect  {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x = rect.size.height / 3;

    // STOP NAME
    NSString *routeName = self.model.stop.name2;
    NSDictionary *routeNameDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17],
                                           NSForegroundColorAttributeName: [UIColor blackColor]};
    CGFloat routeNameHeight = [routeName boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:routeNameDictionary
                                                      context:nil].size.height;
    CGRect routeNameRect = CGRectMake(60, x, rect.size.width - 60, routeNameHeight);
    [routeName drawInRect:routeNameRect withAttributes:routeNameDictionary];

    // TIMES OF ARRIVAL
    NSString *timesOfArrival = self.model.formattedTimesOfArrival;
    NSDictionary *timesOfArrivalDirectory = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:12],
                                               NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    CGFloat timesOfArrivalHeight = [timesOfArrival boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:timesOfArrivalDirectory
                                                                context:nil].size.height;
    CGRect timesOfArrivalRect = CGRectMake(60, x + routeNameHeight, rect.size.width - 60, timesOfArrivalHeight);
    [timesOfArrival drawInRect:timesOfArrivalRect withAttributes:timesOfArrivalDirectory];
    
    // VERTICAL LINE
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.811630 green:0.811630 blue:0.811630 alpha:1.0000].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 30, 0);
    CGContextAddLineToPoint(context, 30, rect.size.height);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.75);
    
    // FIRST ARRIVAL TIME CIRCLE
    CGRect circleRect = CGRectMake(10, x - 10, 40, 40);

    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillEllipseInRect(context, circleRect);
    
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.811630 green:0.811630 blue:0.811630 alpha:1.0000].CGColor);
    CGContextStrokeEllipseInRect(context, circleRect);
    
    // ABBREVIATED FIRST ARRIVAL TIME
    NSString *firstTimeOfArrival = self.model.abbreviatedFirstArrivalString;
    UIColor *firstTimeOfArrivalColor = [firstTimeOfArrival isEqualToString:@"Arr"] ?
                                        [UIColor colorWithHexString:self.model.arrival.busRouteColor] :
                                        [UIColor colorWithRed:0.576660 green:0.576660 blue:0.576660 alpha:1.0000];
    NSDictionary *firstTimeOfArrivalDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:12],
                                                    NSForegroundColorAttributeName: firstTimeOfArrivalColor};
    CGRect firstTimeOfArrivalRect = [firstTimeOfArrival boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:firstTimeOfArrivalDictionary
                                                                     context:nil];
    CGRect arrivalTimeRect = CGRectMake(circleRect.origin.x + ((circleRect.size.width - firstTimeOfArrivalRect.size.width) / 2),
                                        circleRect.origin.y + (circleRect.size.height - (firstTimeOfArrivalRect.size.height * 2)),
                                        firstTimeOfArrivalRect.size.width,
                                        firstTimeOfArrivalRect.size.height);
    [firstTimeOfArrival drawInRect:arrivalTimeRect withAttributes:firstTimeOfArrivalDictionary];
}

@end
