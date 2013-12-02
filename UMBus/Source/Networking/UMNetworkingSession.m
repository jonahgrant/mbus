//
//  BusSession.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "UMNetworkingSession.h"
#import "AFHTTPRequestOperationManager.h"
#import "UMResponseSerializer.h"
#import "Bus.h"
#import "Stop.h"
#import "Announcement.h"

#define HandlerBlock(b) ((b) ? (^(AFHTTPRequestOperation *_, id x){ (b)(x); }) : NULL)

@interface UMNetworkingSession ()

@property (nonatomic, readonly) AFHTTPRequestOperationManager *manager;

- (NSString *)rootURLWithPath:(NSString *)path;

@end

@implementation UMNetworkingSession

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

- (void)fetchStopsWithSuccessBlock:(void(^)(NSArray *))success errorBlock:(UMErrorBlock)error {
    [[self.manager GET:[self rootURLWithPath:@"/stops"]
            parameters:nil
               success:HandlerBlock(success)
               failure:HandlerBlock(error)]
     setResponseSerializer:[Stop um_arrayResponseSerializer]];
}

- (void)fetchAnnouncementsWithSuccessBlock:(void(^)(NSArray *))success errorBlock:(UMErrorBlock)error {
    [[self.manager GET:[self rootURLWithPath:@"/announcements"]
            parameters:nil
               success:HandlerBlock(success)
               failure:HandlerBlock(error)]
     setResponseSerializer:[Announcement um_arrayResponseSerializer]];
}

@end
