//
//  StopArrivalCellView.m
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopArrivalCellView.h"
#import "StopArrivalCellModel.h"
#import "Arrival.h"
#import "HexColor.h"

@interface StopArrivalCellView ()

@property (strong, nonatomic) UIColor *routeColor;
@property (nonatomic, copy) NSString *arrivingInPrefix, *abbreviatedArrivalTime;

@end

@implementation StopArrivalCellView

- (instancetype)initWithFrame:(CGRect)frame arrivalModel:(StopArrivalCellModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
        
        [RACObserve(self, model) subscribeNext:^(id x) {
            NSTimeInterval firstArrival = [self.model firstArrival];
            self.routeColor = [UIColor colorWithHexString:self.model.arrival.busRouteColor];
            self.arrivingInPrefix = [self.model arrivalPrefixTimeForTimeInterval:firstArrival];
            self.abbreviatedArrivalTime = [self.model abbreviatedArrivalTimeForTimeInterval:firstArrival];

            [self setNeedsDisplay];
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x = 20;
    
    NSString *routeName = self.model.arrival.name;
    UIColor *busRouteColor = self.routeColor;
    
    NSDictionary *routeNameDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15],
                                           NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGFloat routeNameHeight = [routeName boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:routeNameDictionary
                                                      context:nil].size.height;
    
    CGRect routeNameRect = CGRectMake(40, x - 7, rect.size.width - 50, routeNameHeight);
    
    CGContextSetFillColorWithColor(context, busRouteColor.CGColor);
    CGRect circlePoint = CGRectMake(10, x - 7, 15, 15);
    CGContextFillEllipseInRect(context, circlePoint);
    
    [routeName drawInRect:routeNameRect withAttributes:routeNameDictionary];
    
    // Divider line
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.882855 green:0.882855 blue:0.882855 alpha:1.0000].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 10, x + routeNameHeight + 5);
    CGContextAddLineToPoint(context, self.bounds.size.width - 20, x + routeNameHeight + 5);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);

    NSString *arrivingIn = self.arrivingInPrefix;
    
    NSMutableParagraphStyle *arrivingInParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    arrivingInParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    arrivingInParagraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *arrivingInDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13],
                                            NSForegroundColorAttributeName: [UIColor darkGrayColor],
                                            NSParagraphStyleAttributeName: arrivingInParagraphStyle};
    
    CGRect arrivingInTextRec = [arrivingIn boundingRectWithSize:CGSizeMake(320, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:arrivingInDictionary
                                                        context:nil];
    
    CGRect arrivingInRect = CGRectMake(0, 70, 320, arrivingInTextRec.size.height);
    
    [arrivingIn drawInRect:arrivingInRect withAttributes:arrivingInDictionary];
    
    NSString *arrivingInTime = self.abbreviatedArrivalTime;
    
    NSMutableParagraphStyle *arrivingInTimeParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    arrivingInTimeParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    arrivingInTimeParagraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *arrivingInTimeDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17],
                                                NSForegroundColorAttributeName: [UIColor redColor],
                                                NSParagraphStyleAttributeName: arrivingInTimeParagraphStyle};
    
    CGFloat arrivingInTimeHeight = [routeName boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:arrivingInTimeDictionary
                                                       context:nil].size.height;
    
    CGRect arrivingInTimeRect = CGRectMake(0, 85, 320, arrivingInTimeHeight);
    
    [arrivingInTime drawInRect:arrivingInTimeRect withAttributes:arrivingInTimeDictionary];

    // Cell seperator
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
