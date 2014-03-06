//
//  CircleAnnotationView.m
//  UMBus
//
//  Created by Jonah Grant on 12/8/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

// Based off of SVPulsingAnnotationView

#import <QuartzCore/QuartzCore.h>
#import "CircleAnnotationView.h"

@interface CircleAnnotationView ()

@property (strong, nonatomic) UIColor *annotationColor, *outlineColor;

@property (nonatomic, readwrite) BOOL shouldBeFlat;

@property (nonatomic, strong) CALayer *shinyDotLayer;
@property (nonatomic, strong) CALayer *glowingHaloLayer;

@property (nonatomic, strong) CALayer *whiteDotLayer;
@property (nonatomic, strong) CALayer *colorDotLayer;

@property (nonatomic, strong) CAAnimationGroup *pulseAnimationGroup;

@end

@implementation CircleAnnotationView

+ (NSMutableDictionary*)cachedRingImages {
    static NSMutableDictionary *cachedRingLayers = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ cachedRingLayers = [NSMutableDictionary new]; });
    return cachedRingLayers;
}

- (BOOL)shouldBeFlat {
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] == NSOrderedDescending);
}

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                             color:(UIColor *)color
                      outlineColor:(UIColor *)outlineColor {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 28, 28);
        self.opaque = NO;
        [self setAnnotationColor:color];
        self.outlineColor = outlineColor;
        
        self.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.bounds = CGRectMake(0, 0, 22, 22);
    }
    return self;
}

- (void)rebuildLayers {
    if(self.shouldBeFlat) {
        [_whiteDotLayer removeFromSuperlayer];
        _whiteDotLayer = nil;
        
        [_colorDotLayer removeFromSuperlayer];
        _colorDotLayer = nil;
        
        [self.layer addSublayer:self.whiteDotLayer];
        [self.layer addSublayer:self.colorDotLayer];
    }
    else {
        [_glowingHaloLayer removeFromSuperlayer];
        _glowingHaloLayer = nil;
        
        [_shinyDotLayer removeFromSuperlayer];
        _shinyDotLayer = nil;
        
        [self.layer addSublayer:self.glowingHaloLayer];
        [self.layer addSublayer:self.shinyDotLayer];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if(newSuperview) {
        [self rebuildLayers];
        [self popIn];
    }
}

- (void)popIn {
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    CAMediaTimingFunction *easeInOut = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    bounceAnimation.values = @[@0.05, @1.25, @0.8, @1.1, @0.9, @1.0];
    bounceAnimation.duration = 0.3;
    bounceAnimation.timingFunctions = @[easeInOut, easeInOut, easeInOut, easeInOut, easeInOut, easeInOut];
    [(self.shouldBeFlat ? self.layer : self.shinyDotLayer) addAnimation:bounceAnimation forKey:@"popIn"];
}

#pragma mark - Setters

- (void)setAnnotationColor:(UIColor *)annotationColor {
    if(CGColorGetNumberOfComponents(annotationColor.CGColor) == 2) {
        float white = CGColorGetComponents(annotationColor.CGColor)[0];
        float alpha = CGColorGetComponents(annotationColor.CGColor)[1];
        annotationColor = [UIColor colorWithRed:white green:white blue:white alpha:alpha];
    }
    _annotationColor = annotationColor;
    
    if(self.superview)
        [self rebuildLayers];
}

- (CAAnimationGroup*)pulseAnimationGroup {
    if(!_pulseAnimationGroup) {
        CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        _pulseAnimationGroup = [CAAnimationGroup animation];
        _pulseAnimationGroup.repeatCount = INFINITY;
        _pulseAnimationGroup.removedOnCompletion = NO;
        _pulseAnimationGroup.timingFunction = defaultCurve;
        
        NSMutableArray *animations = [NSMutableArray new];
        
        
        
        CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
        pulseAnimation.fromValue = @0.0;
        pulseAnimation.toValue = @1.0;
        [animations addObject:pulseAnimation];
        
        
        if(!self.shouldBeFlat) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animation.fromValue = @1.0;
            animation.toValue = @0.0;
            animation.timingFunction = defaultCurve;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            [animations addObject:animation];
        }
        else {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            animation.values = @[@0.45, @0.45, @0];
            animation.keyTimes = @[@0, @0.2, @1];
            animation.removedOnCompletion = NO;
            [animations addObject:animation];
        }
        
        _pulseAnimationGroup.animations = animations;
    }
    return _pulseAnimationGroup;
}

#pragma mark - iOS 7

- (CALayer*)whiteDotLayer {
    if(!_whiteDotLayer) {
        _whiteDotLayer = [CALayer layer];
        _whiteDotLayer.bounds = self.bounds;
        _whiteDotLayer.contents = (id)[self circleImageWithColor:[UIColor whiteColor] height:22].CGImage;
        _whiteDotLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        _whiteDotLayer.contentsGravity = kCAGravityCenter;
        _whiteDotLayer.contentsScale = [UIScreen mainScreen].scale;
        _whiteDotLayer.shadowColor = [UIColor blackColor].CGColor;
        _whiteDotLayer.shadowOffset = CGSizeMake(0, 2);
        _whiteDotLayer.shadowRadius = 3;
        _whiteDotLayer.shadowOpacity = 0.3;
        _whiteDotLayer.shouldRasterize = YES;
        _whiteDotLayer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return _whiteDotLayer;
}

- (CALayer *)colorDotLayer {
    if(!_colorDotLayer) {
        _colorDotLayer = [CALayer layer];
        _colorDotLayer.bounds = CGRectMake(0, 0, 16, 16);
        _colorDotLayer.allowsGroupOpacity = YES;
        _colorDotLayer.backgroundColor = self.annotationColor.CGColor;
        _colorDotLayer.cornerRadius = 8;
        _colorDotLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
    return _colorDotLayer;
}

- (UIImage *)circleImageWithColor:(UIColor*)color height:(float)height {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(height, height), NO, 0);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UIBezierPath* fillPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, height, height)];
    [color setFill];
    [fillPath fill];
    
    UIImage *dotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGColorSpaceRelease(colorSpace);
    
    return dotImage;
}

@end
