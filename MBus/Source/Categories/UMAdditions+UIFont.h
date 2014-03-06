//
//  UMAdditions+UIFont.h
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

typedef NS_ENUM(NSInteger, TypeWeight) {
    TypeWeightNormal,
    TypeWeightBold,
    TypeWeightLight,
    TypeWeightLightItalic
};

@interface UIFont (UMAdditions)

+ (UIFont *)helveticaNeueWithWeight:(TypeWeight)weight size:(NSInteger)size;

@end