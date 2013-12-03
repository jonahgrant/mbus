//
//  Route.m
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "Route.h"
#import "Stop.h"

@implementation Route

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"isActive" : @"is_active",
             @"topOfLoopStopID" : @"top_of_loop_stop_id"};
}

@end
