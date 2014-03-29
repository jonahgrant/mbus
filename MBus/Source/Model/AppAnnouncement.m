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
    for (NSString *string in @[@"’s iPhone", @"’s iPad", @"’s iPod touch", @"’s iPod",
                               @"'s iPhone", @"'s iPad", @"'s iPod touch", @"'s iPod",
                               @"s iPhone", @"s iPad", @"s iPod touch", @"s iPod"]) {
        NSRange ownershipRange = [deviceName rangeOfString:string];
        
        if (ownershipRange.location != NSNotFound) {
            return [deviceName substringToIndex:ownershipRange.location];
        }
    }
    
    return nil;
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
             @"backgroundColor": @"background_color"};
}

#pragma mark - NSObject

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"Title: %@\nText: %@\nType: %@\nColor: %@\nAction: %@\nAction destination: %@\nAction body: %@", self.title, self.text, self.type, self.color, self.action, self.actionDestination, self.actionBody];
}


@end
