//
//  HMRectBackgroundLabel.h
//
//  Created by Brandon Butler on 9/20/11.
//  
//

#import "HMRectBackgroundLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation HMRectBackgroundLabel

@synthesize cornerRadius;
@synthesize rectColor;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

    }
    return self;
}
- (void) setBackgroundColor:(UIColor *)color
{
	self.rectColor = color;
	[super setBackgroundColor:[UIColor clearColor]];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	if(cornerRadius == 0)
		self.cornerRadius = 8;
	[self drawRoundedRect:context rect:rect radius:cornerRadius color:rectColor];
	[super drawRect:rect];
}

- (void) drawRoundedRect:(CGContextRef)c rect:(CGRect)rect radius:(int)corner_radius color:(UIColor *)color
{
	int x_left = rect.origin.x;
	int x_left_center = rect.origin.x + corner_radius;
	int x_right_center = rect.origin.x + rect.size.width - corner_radius;
	int x_right = rect.origin.x + rect.size.width;
    
	int y_top = rect.origin.y;
	int y_top_center = rect.origin.y + corner_radius;
	int y_bottom_center = rect.origin.y + rect.size.height - corner_radius;
	int y_bottom = rect.origin.y + rect.size.height;
    
	/* Begin! */
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, x_left, y_top_center);
    
	/* First corner */
	CGContextAddArcToPoint(c, x_left, y_top, x_left_center, y_top, corner_radius);
	CGContextAddLineToPoint(c, x_right_center, y_top);
    
	/* Second corner */
	CGContextAddArcToPoint(c, x_right, y_top, x_right, y_top_center, corner_radius);
	CGContextAddLineToPoint(c, x_right, y_bottom_center);
    
	/* Third corner */
	CGContextAddArcToPoint(c, x_right, y_bottom, x_right_center, y_bottom, corner_radius);
	CGContextAddLineToPoint(c, x_left_center, y_bottom);
    
	/* Fourth corner */
	CGContextAddArcToPoint(c, x_left, y_bottom, x_left, y_bottom_center, corner_radius);
	CGContextAddLineToPoint(c, x_left, y_top_center);
    
	/* Done */
	CGContextClosePath(c);
    
	CGContextSetFillColorWithColor(c, color.CGColor);
    
	CGContextFillPath(c);
}

@end
