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

@interface StopArrivalCellView ()

@property (strong, nonatomic) UIColor *routeColor;
@property (nonatomic, copy) NSString *abbreviatedArrivalTime, *arrivalTimeSuffix;

@end

@implementation StopArrivalCellView

- (instancetype)initWithFrame:(CGRect)frame arrivalModel:(StopArrivalCellModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
        
        [[RACObserve(self, model) filter:^BOOL(StopArrivalCellModel *model) {
            return (model != nil);
        }] subscribeNext:^(StopArrivalCellModel *model) {
            self.routeColor = self.model.arrival.routeColor;
            self.abbreviatedArrivalTime = self.model.firstArrivalString;
            self.arrivalTimeSuffix = self.model.firstArrivalSuffix;
            
            [self setNeedsDisplay];
        }];
    }
    return self;
}

// this is very dirty, I'm sorry.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x = 20;
    
    NSString *routeName = self.model.arrival.name;
    
    NSDictionary *routeNameDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15],
                                           NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGFloat routeNameHeight = [routeName boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:routeNameDictionary
                                                      context:nil].size.height;
    
    CGRect routeNameRect = CGRectMake(20, x - 7, rect.size.width - 50, routeNameHeight);
    
    // Route color rect
    CGContextSetFillColorWithColor(context, self.routeColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 5, rect.size.height));
    
    [routeName drawInRect:routeNameRect withAttributes:routeNameDictionary];
    
    // Divider line
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.882855 green:0.882855 blue:0.882855 alpha:1.0000].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 20, x + routeNameHeight + 5);
    CGContextAddLineToPoint(context, self.bounds.size.width, x + routeNameHeight + 5);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);

    NSString *arrivingInTime = self.abbreviatedArrivalTime;
    
    int arrivingInTimeFontSize = ([arrivingInTime isEqualToString:@"Arriving Now"]) ? 40 : 70;
    int arrivingInTimeY = ([arrivingInTime isEqualToString:@"Arriving Now"]) ? 80 : 53;

    NSDictionary *arrivingInTimeDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-UltraLight"
                                                                                     size:arrivingInTimeFontSize],
                                                NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGRect arrivingInTimeHeight = [arrivingInTime boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:arrivingInTimeDictionary
                                                               context:nil];
    
    CGRect arrivingInTimeRect = CGRectMake(15, arrivingInTimeY, arrivingInTimeHeight.size.width, arrivingInTimeHeight.size.height);
    
    [arrivingInTime drawInRect:arrivingInTimeRect withAttributes:arrivingInTimeDictionary];
    
    NSString *arrivingInSuffix = self.arrivalTimeSuffix;
    
    NSDictionary *arrivingInSuffixDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30],
                                                  NSForegroundColorAttributeName: [UIColor grayColor]};
    
    CGFloat arrivingInSuffixHeight = [arrivingInSuffix boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:arrivingInSuffixDictionary
                                                                    context:nil].size.height;
    
    CGRect arrivingInSuffixRect = CGRectMake(arrivingInTimeRect.size.width + arrivingInTimeRect.origin.x + 7, 90, 320, arrivingInSuffixHeight);
    
    [arrivingInSuffix drawInRect:arrivingInSuffixRect withAttributes:arrivingInSuffixDictionary];

    // Cell seperator
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.882855 green:0.882855 blue:0.882855 alpha:1.0000].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 10, rect.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, rect.size.height);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    CGContextSetRGBFillColor(context, 0,0,0,0.75);
}

@end
