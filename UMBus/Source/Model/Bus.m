//
//  Bus.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "Bus.h"

@implementation Bus

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"routeName" : @"route_name"};
}

+ (NSString *)managedObjectEntityName {
    return @"Bus";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:@"heading" forKey:@"heading"];
    [dictionary setObject:@"id" forKey:@"id"];
    [dictionary setObject:@"latitude" forKey:@"latitude"];
    [dictionary setObject:@"longitude" forKey:@"longitude"];
    [dictionary setObject:@"route" forKey:@"route"];
    [dictionary setObject:@"routeName" forKey:@"routeName"];
    
    return dictionary;
}

@end
