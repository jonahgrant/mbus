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
        self.routes = [DataStore sharedManager].arrivals;
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];

        if (!self.routes) {
            [self fetchData];
        }
        
        [RACObserve([DataStore sharedManager], arrivals) subscribeNext:^(NSArray *arrivals) {
            self.routes = arrivals;
        }];
    }
    return self;
}

- (void)fetchData {
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:^(NSError *error) {
        self.routes = self.routes;
    }];
}

- (NSString *)timeSinceLastRefresh {
    if (![[DataStore sharedManager] arrivalsTimestamp]) {
        return kNever;
    }
    
    return [self.timeIntervalFormatter stringForTimeInterval:[[[DataStore sharedManager] arrivalsTimestamp] timeIntervalSinceDate:[NSDate date]]];
}

- (NSString *)footerString {
    return [NSString stringWithFormat:kFormattedStringLastUpdated, [self timeSinceLastRefresh]];
}

@end
