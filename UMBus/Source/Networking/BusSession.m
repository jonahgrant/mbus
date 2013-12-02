//
//  BusSession.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "BusSession.h"
#import "AFHTTPRequestOperationManager.h"
#import "UMResponseSerializer.h"
#import "Bus.h"

#define HandlerBlock(b) ((b) ? (^(AFHTTPRequestOperation *_, id x){ (b)(x); }) : NULL)

@interface BusSession ()

@property (nonatomic, readonly) AFHTTPRequestOperationManager *manager;

- (NSString *)rootURLWithPath:(NSString *)path;

@end

@implementation BusSession

- (instancetype)init {
    if (self = [super init]) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

- (NSString *)rootURLWithPath:(NSString *)path {
    if ([path hasPrefix:@"/"]) {
        return [@"http://mbus.pts.umich.edu/api/v0" stringByAppendingString:path];
    } else {
        return [@"http://mbus.pts.umich.edu/api/v0/" stringByAppendingString:path];
    }
    
    return nil;
}

- (void)fetchBusLocationsWithSuccessBlock:(void(^)(NSArray *))success errorBlock:(UMErrorBlock)error {
    [[self.manager GET:[self rootURLWithPath:@"/buses"]
            parameters:nil
               success:HandlerBlock(success)
               failure:HandlerBlock(error)]
     setResponseSerializer:[Bus um_arrayResponseSerializer]];
}

@end
