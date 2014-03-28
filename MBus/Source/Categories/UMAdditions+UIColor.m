//
//  UMAdditions+UIColor.m
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "UMAdditions+UIColor.h"
#import "Fare+UIColor.h"

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
            return @[[UIColor colorFromHexString:@"FF5E3A"],
                     [UIColor colorFromHexString:@"FF2A68"]];
        case GradientOrange:
            return @[[UIColor colorFromHexString:@"FF9500"],
                     [UIColor colorFromHexString:@"FF5E3A"]];
        case GradientYellow:
            return @[[UIColor colorFromHexString:@"FFDB4C"],
                     [UIColor colorFromHexString:@"FFCD02"]];
        case GradientGreen:
            return @[[UIColor colorFromHexString:@"87FC70"],
                     [UIColor colorFromHexString:@"0BD318"]];
        case GradientLightBlue:
            return @[[UIColor colorFromHexString:@"52EDC7"],
                     [UIColor colorFromHexString:@"5AC8FB"]];
        case GradientDarkBlue:
            return @[[UIColor colorFromHexString:@"1AD6FD"],
                     [UIColor colorFromHexString:@"1D62F0"]];
        case GradientDarkPurple:
            return @[[UIColor colorFromHexString:@"C644FC"],
                     [UIColor colorFromHexString:@"5856D6"]];
        case GradientLightPurple:
            return @[[UIColor colorFromHexString:@"EF4DB6"],
                     [UIColor colorFromHexString:@"C643FC"]];
        case GradientBlack:
            return @[[UIColor colorFromHexString:@"4A4A4A"],
                     [UIColor colorFromHexString:@"2B2B2B"]];
        case GradientGreenToWhite:
            return @[[UIColor colorFromHexString:@"5AD427"],
                     [UIColor colorFromHexString:@"A4E786"]];
        case GradientPurpleToWhite:
            return @[[UIColor colorFromHexString:@"C86EDF"],
                     [UIColor colorFromHexString:@"E4B7F0"]];
        case GradientLightRedInverse:
            return @[[UIColor colorFromHexString:@"FB2B69"],
                     [UIColor colorFromHexString:@"FF5B37"]];
        case GradientLightGray:
            return @[[UIColor colorFromHexString:@"F7F7F7"],
                     [UIColor colorFromHexString:@"D7D7D7"]];
        case GradientDarkBlueToLightBlue:
            return @[[UIColor colorFromHexString:@"1D77EF"],
                     [UIColor colorFromHexString:@"81F3FD"]];
        case GradientBeige:
            return @[[UIColor colorFromHexString:@"D6CEC3"],
                     [UIColor colorFromHexString:@"E4DDCA"]];
        case GradientLightGreenToLightBlue:
            return @[[UIColor colorFromHexString:@"55EFCB"],
                     [UIColor colorFromHexString:@"5BCAFF"]];
    }
    
    return nil;
}

@end
