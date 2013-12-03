//
//  HMRectBackgroundLabel.h
//
//  Created by Brandon Butler on 9/20/11.
//  
//

#import <UIKit/UIKit.h>

@interface HMRectBackgroundLabel : UILabel {
	NSInteger cornerRadius;
	UIColor *rectColor;
}

@property (nonatomic) NSInteger cornerRadius;
@property (nonatomic, strong) UIColor *rectColor;

- (void)setBackgroundColor:(UIColor *)color;
- (void)drawRoundedRect:(CGContextRef)c rect:(CGRect)rect radius:(int)corner_radius color:(UIColor *)color;

@end