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
#import "UMAdditions+UIFont.h"
#import "UMAdditions+UIColor.h"
#import "UIColor+HexString.h"
#import "InitialedCircleView.h"
#import "DistanceTagView.h"

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
        
        self.subtitleDictionary = @{ NSFontAttributeName: [UIFont helveticaNeueWithWeight:TypeWeightLightItalic size:14],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor]};

        self.routeNameDictionary = @{ NSFontAttributeName: [UIFont helveticaNeueWithWeight:TypeWeightLight size:17],
                                      NSForegroundColorAttributeName: [UIColor blackColor]};

        [RACObserve(self, model) subscribeNext:^(id x) {
            self.subtitleHeight = [self.model.stop.uniqueName boundingRectWithSize:CGSizeMake(self.frame.size.width - 105, MAXFLOAT)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:self.subtitleDictionary
                                                                           context:nil].size.height;

            self.routeNameHeight = [self.model.stop.humanName boundingRectWithSize:CGSizeMake(self.frame.size.width - 105, MAXFLOAT)
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

    CGFloat x = rect.size.height / 3;
    
    BOOL isGradient = (self.model.circleColors.count > 1);
    
    drawLinearGradient(context,
                       CGRectMake(10, CGRectGetHeight(rect) / 2 - 35, 60, 60),
                       ((UIColor *)self.model.circleColors[0]).CGColor,
                       (isGradient) ? ((UIColor *)self.model.circleColors[1]).CGColor : ((UIColor *)self.model.circleColors[0]).CGColor,
                       (self.model != nil) ? [self.model initialsForStop:self.model.stop.humanName] : @"");
 
    NSString *routeName = self.model.stop.humanName;
    
    CGRect routeNameRect = CGRectMake(80, x - (self.routeNameHeight / 2) - 5, rect.size.width - 105, self.routeNameHeight);
    
    [routeName drawInRect:routeNameRect withAttributes:self.routeNameDictionary];
    
    NSString *subtitle = self.model.stop.uniqueName;
    
    CGFloat subtitleHeight = [subtitle boundingRectWithSize:CGSizeMake(rect.size.width - 105, 30)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:self.subtitleDictionary
                                                    context:nil].size.height;
    
    CGRect subtitleRect = CGRectMake(80, x + (self.routeNameHeight / 2) - 5, rect.size.width - 105, subtitleHeight);

    [subtitle drawInRect:subtitleRect withAttributes:self.subtitleDictionary];
    
    drawDistanceTagView(context, subtitleRect.origin.y + subtitleHeight + 5, self.model.distance);
}

@end
