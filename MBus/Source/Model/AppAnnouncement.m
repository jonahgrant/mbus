//
//  AppAnnouncement.m
//  MBus
//
//  Created by Jonah Grant on 3/28/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "AppAnnouncement.h"
#import "Mantle.h"
#import "Fare+UIColor.h"

static NSString * const USER_DEVICE_NAME = @"/device_name";

@implementation AppAnnouncement

+ (NSString *)isolatedHumanNameForDeviceName:(NSString *)deviceName {
    deviceName = deviceName.lowercaseString;
    
    for (NSString *string in @[@"’s iphone", @"’s ipad", @"’s ipod touch", @"’s ipod",
                               @"'s iphone", @"'s ipad", @"'s ipod touch", @"'s ipod",
                               @"s iphone", @"s ipad", @"s ipod touch", @"s ipod"]) {
        NSRange ownershipRange = [deviceName rangeOfString:string];
        
        if (ownershipRange.location != NSNotFound) {
            return [[[deviceName substringToIndex:ownershipRange.location] componentsSeparatedByString:@" "][0]
                    stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                            withString:[[deviceName substringToIndex:1] capitalizedString]];
        }
    }
    
    return nil;
}

- (BOOL)supported {
    BOOL supportsMinimum;
    if ([self.minimumVersion isEqualToString:@""]) {
        supportsMinimum = YES;
    } else {
        supportsMinimum = (([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] compare:self.minimumVersion options:NSNumericSearch] == NSOrderedDescending) || ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] compare:self.minimumVersion options:NSNumericSearch] == NSOrderedSame));
    }

    BOOL supportsMaximum;
    if ([self.maximumVersion isEqualToString:@""]) {
        supportsMaximum = YES;
    } else {
        supportsMaximum = (([self.maximumVersion compare:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] options:NSNumericSearch] == NSOrderedDescending) || ([self.maximumVersion compare:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] options:NSNumericSearch] == NSOrderedSame));
    }
    
    return (supportsMinimum && supportsMaximum);
}

#pragma mark - NSValueTransformer

+ (NSValueTransformer *)colorJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *color) {
        return [UIColor colorFromHexString:color];
    } reverseBlock:^id(UIColor *color) {
        return [UIColor hexStringFromUIColor:color];
    }];
}

+ (NSValueTransformer *)backgroundColorJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *color) {
        return [UIColor colorFromHexString:color];
    } reverseBlock:^id(UIColor *color) {
        return [UIColor hexStringFromUIColor:color];
    }];
}

+ (NSValueTransformer *)textJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *text) {
        if ([text rangeOfString:USER_DEVICE_NAME].location != NSNotFound) {
            NSString *name = [AppAnnouncement isolatedHumanNameForDeviceName:[UIDevice currentDevice].name];
            
            if (name == nil) {
                name = @"MBus user";
            }
            
            return [text stringByReplacingOccurrencesOfString:USER_DEVICE_NAME withString:name];
        } else {
            return text;
        }
    } reverseBlock:^id(NSString *text) {
        return text;
    }];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"actionDestination": @"action_destination",
             @"actionBody": @"action_body",
             @"backgroundColor": @"background_color",
             @"minimumVersion": @"minimum_version",
             @"maximumVersion": @"maximum_version"};
}

#pragma mark - NSObject

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"Title: %@\nText: %@\nType: %@\nColor: %@\nAction: %@\nAction destination: %@\nAction body: %@\nMinimum version: %@\nTag: %@",
            self.title,
            self.text,
            self.type,
            self.color,
            self.action,
            self.actionDestination,
            self.actionBody,
            self.minimumVersion,
            self.tag];
}


@end
