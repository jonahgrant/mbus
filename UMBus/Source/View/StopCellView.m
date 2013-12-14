//
//  StopCellView.m
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopCellView.h"
#import "StopCellModel.h"
#import "Stop.h"

@implementation StopCellView

- (instancetype)initWithFrame:(CGRect)frame arrivalModel:(StopCellModel *)model {
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

    CGFloat x = rect.size.height / 3 + 10;
    
    NSString *routeName = self.model.stop.humanName;
    
    NSDictionary *routeNameDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17],
                                           NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGFloat routeNameHeight = [routeName boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:routeNameDictionary
                                                      context:nil].size.height;
    
    CGRect routeNameRect = CGRectMake(40, x - (routeNameHeight / 2), rect.size.width - 50, routeNameHeight);
    
    [routeName drawInRect:routeNameRect withAttributes:routeNameDictionary];
    
    NSString *distance = [[self.model distance] stringByAppendingString:@" away"];
    
    NSDictionary *distanceDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14],
                                           NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    CGFloat distanceHeight = [routeName boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:routeNameDictionary
                                                      context:nil].size.height;
    
    CGRect distanceRect = CGRectMake(40, x + (routeNameHeight / 2) + 5, rect.size.width - 50, distanceHeight);

    [distance drawInRect:distanceRect withAttributes:distanceDictionary];

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
