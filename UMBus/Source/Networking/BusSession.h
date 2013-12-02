//
//  BusSession.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

typedef void (^UMErrorBlock)(NSError *error);

@interface BusSession : NSObject

- (void)fetchBusLocationsWithSuccessBlock:(void(^)(NSArray *))success errorBlock:(UMErrorBlock)error;

@end
