//
//  UMAdditions+UIFont.m
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "UMAdditions+UIFont.h"

@interface UIFont (UMAdditionsPrivate)

+ (NSString *)stringForWeight:(TypeWeight)weight;

@end

@implementation UIFont (UMAdditions)

+ (UIFont *)helveticaNeueWithWeight:(TypeWeight)weight size:(NSInteger)size {
    return [UIFont fontWithName:[@"HelveticaNeue" stringByAppendingString:[UIFont stringForWeight:weight]] size:size];
}

+ (NSString *)stringForWeight:(TypeWeight)weight {
    switch (weight) {
        case TypeWeightNormal:
            return @"";
        case TypeWeightBold:
            return @"-Bold";
        case TypeWeightLight:
            return @"-Light";
        case TypeWeightLightItalic:
            return @"-LightItalic";
    }
    
    return nil;
}

@end