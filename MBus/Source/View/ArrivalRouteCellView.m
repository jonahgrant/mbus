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
    
    NSDictionary *routeNameDictionary = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:17],
                                           NSForegroundColorAttributeName: [UIColor blackColor]};
    CGFloat routeNameHeight = [routeName boundingRectWithSize:CGSizeMake(rect.size.width - 20, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:routeNameDictionary
                                                      context:nil].size.height;
    CGRect routeNameRect = CGRectMake(20, x - (routeNameHeight / 2), rect.size.width - 50, routeNameHeight);
    
    [routeName drawInRect:routeNameRect withAttributes:routeNameDictionary];

    // Route color rect
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:self.model.arrival.busRouteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 5, rect.size.height));
}

@end
