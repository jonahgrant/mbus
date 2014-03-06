//
//  UMAdditions+UIColor.h
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

typedef NS_ENUM(NSInteger, Solid) {
    SolidRed,
    SolidOrange,
    SolidYellow,
    SolidGreen,
    SolidLightBlue,
    SolidDarkBlue,
    SolidDarkPurple,
    SolidLightRed,
    SolidDarkGray,
    SolidLightGray,
    SolidBabyBlue,
    SuperLightGreen,
    SolidPink,
    SolidLightPink,
    SolidSuperLightGray,
    SolidDarkRed,
    SolidBlack,
    SolidGray,
    SolidSoftRed
};

typedef NS_ENUM(NSInteger, Gradient) {
    GradientLightRed,
    GradientOrange,
    GradientYellow,
    GradientGreen,
    GradientLightBlue,
    GradientDarkBlue,
    GradientDarkPurple,
    GradientLightPurple,
    GradientBlack,
    GradientGreenToWhite,
    GradientPurpleToWhite,
    GradientLightRedInverse,
    GradientLightGray,
    GradientDarkBlueToLightBlue,
    GradientBeige,
    GradientLightGreenToLightBlue
};

@interface UIColor (UMAdditions)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (NSArray *)randomGradient;

+ (NSArray *)gradientForStyle:(Gradient)style;

@end