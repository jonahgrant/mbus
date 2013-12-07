//
//  DataStore.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "DataStore.h"
#import "UMNetworkingSession.h"
#import "Arrival.h"

@interface DataStore ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;
@property (strong, nonatomic, readwrite) NSArray *arrivals;

@end

@implementation DataStore

#pragma mark Singleton Methods

+ (instancetype)sharedManager {
    static DataStore *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
    }
    return self;
}

- (void)handleError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)fetchArrivals {
    [self.networkingSession fetchArrivalsWithSuccessBlock:^(NSArray *array) {
        self.arrivals = array;
    } errorBlock:^(NSError *error) {
        [self handleError:error];
    }];
}

- (Arrival *)arrivalForID:(NSString *)arrivalID {
    for (Arrival *arrival in self.arrivals) {
        if ([arrival.id isEqualToString:arrivalID]) {
            return arrival;
        }
    }
    
    return 0;
}

@end
