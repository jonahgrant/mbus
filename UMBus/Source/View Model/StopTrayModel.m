//
//  StopTrayModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "StopTrayModel.h"
#import "StopAnnotation.h"
#import "UMNetworkingSession.h"
#import "TTTLocationFormatter.h"
#import "Route.h"
#import "Stop.h"
#import "Bus.h"

@interface StopTrayModel ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;

@end

@implementation StopTrayModel

- (instancetype)init {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
    }
    return self;
}

@end
