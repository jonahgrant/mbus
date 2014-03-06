//
//  UMAdditions+UIColor.m
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "UMAdditions+UIColor.h"
#import "UIColor+HexString.h"

static char * const hexFormat = "#%02X%02X%02X";
static NSInteger const gradientCount = 16;

@implementation UIColor (UMAdditions)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSUInteger r, g, b;
    sscanf([hexString UTF8String], hexFormat, &r, &g, &b);
    
    return [UIColor colorWithRed:r / 255.0
                           green:g / 255.0
                            blue:b / 255.0
                           alpha:1];
}

+ (NSArray *)randomGradient {
    return [UIColor gradientForStyle:arc4random_uniform(gradientCount)];
}

+ (NSArray *)gradientForStyle:(Gradient)style {
    switch (style) {
        case GradientLightRed:
            return @[[UIColor colorWithHexString:@"FF5E3A"],
                     [UIColor colorWithHexString:@"FF2A68"]];
        case GradientOrange:
            return @[[UIColor colorWithHexString:@"FF9500"],
                     [UIColor colorWithHexString:@"FF5E3A"]];
        case GradientYellow:
            return @[[UIColor colorWithHexString:@"FFDB4C"],
                     [UIColor colorWithHexString:@"FFCD02"]];
        case GradientGreen:
            return @[[UIColor colorWithHexString:@"87FC70"],
                     [UIColor colorWithHexString:@"0BD318"]];
        case GradientLightBlue:
            return @[[UIColor colorWithHexString:@"52EDC7"],
                     [UIColor colorWithHexString:@"5AC8FB"]];
        case GradientDarkBlue:
            return @[[UIColor colorWithHexString:@"1AD6FD"],
                     [UIColor colorWithHexString:@"1D62F0"]];
        case GradientDarkPurple:
            return @[[UIColor colorWithHexString:@"C644FC"],
                     [UIColor colorWithHexString:@"5856D6"]];
        case GradientLightPurple:
            return @[[UIColor colorWithHexString:@"EF4DB6"],
                     [UIColor colorWithHexString:@"C643FC"]];
        case GradientBlack:
            return @[[UIColor colorWithHexString:@"4A4A4A"],
                     [UIColor colorWithHexString:@"2B2B2B"]];
        case GradientGreenToWhite:
            return @[[UIColor colorWithHexString:@"5AD427"],
                     [UIColor colorWithHexString:@"A4E786"]];
        case GradientPurpleToWhite:
            return @[[UIColor colorWithHexString:@"C86EDF"],
                     [UIColor colorWithHexString:@"E4B7F0"]];
        case GradientLightRedInverse:
            return @[[UIColor colorWithHexString:@"FB2B69"],
                     [UIColor colorWithHexString:@"FF5B37"]];
        case GradientLightGray:
            return @[[UIColor colorWithHexString:@"F7F7F7"],
                     [UIColor colorWithHexString:@"D7D7D7"]];
        case GradientDarkBlueToLightBlue:
            return @[[UIColor colorWithHexString:@"1D77EF"],
                     [UIColor colorWithHexString:@"81F3FD"]];
        case GradientBeige:
            return @[[UIColor colorWithHexString:@"D6CEC3"],
                     [UIColor colorWithHexString:@"E4DDCA"]];
        case GradientLightGreenToLightBlue:
            return @[[UIColor colorWithHexString:@"55EFCB"],
                     [UIColor colorWithHexString:@"5BCAFF"]];
    }
    
    return nil;
}

@end
