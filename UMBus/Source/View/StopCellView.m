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

@interface StopCellView ()

@property (nonatomic) CGFloat routeNameHeight, subtitleHeight;
@property (strong, nonatomic) NSDictionary *subtitleDictionary, *routeNameDictionary;

@end

@implementation StopCellView

- (instancetype)initWithFrame:(CGRect)frame arrivalModel:(StopCellModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
        
        self.subtitleDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor]};

        self.routeNameDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17],
                                      NSForegroundColorAttributeName: [UIColor blackColor]};

        [RACObserve(self, model) subscribeNext:^(id x) {
            self.subtitleHeight = [self.model.stop.uniqueName boundingRectWithSize:CGSizeMake(self.frame.size.width - 50, MAXFLOAT)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:self.subtitleDictionary
                                                                           context:nil].size.height;

            self.routeNameHeight = [self.model.stop.humanName boundingRectWithSize:CGSizeMake(self.frame.size.width - 50, MAXFLOAT)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:self.routeNameDictionary
                                                                           context:nil].size.height;

            
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
    
    CGRect routeNameRect = CGRectMake(10, x - (self.routeNameHeight / 2), rect.size.width - 50, self.routeNameHeight);
    
    [routeName drawInRect:routeNameRect withAttributes:self.routeNameDictionary];
    
    NSString *subtitle = self.model.stop.uniqueName;
    
    CGFloat subtitleHeight = [subtitle boundingRectWithSize:CGSizeMake(rect.size.width - 50, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:self.subtitleDictionary
                                                      context:nil].size.height;
    
    CGRect subtitleRect = CGRectMake(10, x + (self.routeNameHeight / 2) + 5, rect.size.width - 50, subtitleHeight);

    [subtitle drawInRect:subtitleRect withAttributes:self.subtitleDictionary];

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
