//
//  RoutesViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RoutesViewControllerModel.h"
#import "TTTTimeIntervalFormatter.h"
#import "DataStore.h"
#import "Constants.h"

@interface RoutesViewControllerModel ()

@property (strong, nonatomic) TTTTimeIntervalFormatter *timeIntervalFormatter;

@end

@implementation RoutesViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];

    
        [[RACObserve([DataStore sharedManager], arrivals) filter:^BOOL(NSArray *arrivals) {
            return (arrivals.count > 0 && self.dataUpdatedBlock);
        }] subscribeNext:^(NSArray *arrivals) {
            self.dataUpdatedBlock();
        }];
    }
    return self;
}

- (void)fetchData {
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:^(NSError *error) {
        self.dataUpdatedBlock();
    }];
}

- (NSString *)timeSinceLastRefresh {
    if (![[DataStore sharedManager] arrivalsTimestamp]) {
        return NEVER;
    }
    
    return [self.timeIntervalFormatter stringForTimeInterval:[[[DataStore sharedManager] arrivalsTimestamp] timeIntervalSinceDate:[NSDate date]]];
}

- (NSString *)footerString {
    return [NSString stringWithFormat:FORMATTED_LAST_UPDATED, [self timeSinceLastRefresh]];
}

@end
