//
//  InitialedCircleView.h
//  MBus
//
//  Created by Jonah Grant on 2/24/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

@interface InitialedCircleView : UIView

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor, NSString *initials);

@end
