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

- (NSString *)timeOfArrivalForTimeInterval:(NSTimeInterval)interval {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
    return [dateFormatter stringFromDate:date];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x = rect.size.height / 2;
    
    NSString *routeName = self.model.stop.name2;
    
    NSTimeInterval toa;
    if (self.model.stop.timeOfArrival >= self.model.stop.timeOfArrival2) {
        NSLog(@"toa1: %f is greater than toa2: %f", self.model.stop.timeOfArrival, self.model.stop.timeOfArrival2);
        toa = self.model.stop.timeOfArrival2;
    } else {
        NSLog(@"toa2: %f is greater than toa1: %f", self.model.stop.timeOfArrival2, self.model.stop.timeOfArrival);
        toa = self.model.stop.timeOfArrival;
    }
    
    NSString *routeTimeOfArrival = [self.model abbreviatedArrivalTimeForTimeInterval:toa];
    
    NSString *eta = [@"Bus 1 arriving at " stringByAppendingString:[self timeOfArrivalForTimeInterval:self.model.stop.timeOfArrival]];
    
    NSDictionary *etaDirectory = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:12],
                                    NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
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
    
    // Stop name and eta
    [routeName drawInRect:routeNameRect withAttributes:routeNameDictionary];
    
    if (self.model.stop.timeOfArrival) {
        CGFloat etaHeight = [eta boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:etaDirectory
                                              context:nil].size.height;
        CGRect etaRect = CGRectMake(60, x + routeNameHeight, rect.size.width - 60, etaHeight);
        [eta drawInRect:etaRect withAttributes:etaDirectory];
    }

    if (self.model.stop.timeOfArrival2) {
        NSString *eta2 = [@"Bus 2 arriving at " stringByAppendingString:[self timeOfArrivalForTimeInterval:self.model.stop.timeOfArrival2]];
        CGFloat etaHeight = [eta boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:etaDirectory
                                              context:nil].size.height;
        CGFloat eta2Height = [eta2 boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:etaDirectory
                                                context:nil].size.height;
        CGRect etaRect = CGRectMake(60, x + routeNameHeight, rect.size.width - 60, etaHeight);
        CGRect eta2Rect = CGRectMake(60, etaRect.origin.y + etaHeight, rect.size.width - 60, eta2Height);
        [eta2 drawInRect:eta2Rect withAttributes:etaDirectory];
    }
    
    // Vertical line
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.811630 green:0.811630 blue:0.811630 alpha:1.0000].CGColor);
    CGContextSetLineWidth(context, 8.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 30, 0);
    CGContextAddLineToPoint(context, 30, rect.size.height);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    CGContextSetRGBFillColor(context, 0,0,0,0.75);

    // Arrival time circle
    CGContextSetFillColorWithColor(context, busRouteColor.CGColor);
    CGContextFillEllipseInRect(context, circleRect);
    
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.811630 green:0.811630 blue:0.811630 alpha:1.0000].CGColor);
    CGContextStrokeEllipseInRect(context, circleRect);
    
    [routeTimeOfArrival drawInRect:arrivalTimeRect withAttributes:arrivalTimeDictionary];
}


@end
