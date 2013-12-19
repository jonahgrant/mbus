//
//  DataStore.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "DataStore.h"
#import "UMNetworkingSession.h"
#import "LocationManager.h"
#import "Arrival.h"
#import "ArrivalStop.h"
#import "Bus.h"
#import "Stop.h"

static NSString * kLastKnownLocation = @"lastKnownLocation.txt";
static NSString * kStopsFile = @"stops.txt";
static NSString * kBusesFile = @"buses.txt";
static NSString * kAnnouncementsFile = @"announcements.txt";
static NSString * kArrivalsFile = @"arrivals.txt";

@interface DataStore ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;

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
        
        [RACObserve([LocationManager sharedManager], currentLocation) subscribeNext:^(CLLocation *location) {
            if (location) {
                self.lastKnownLocation = location;
                [self persistArray:@[location] withFileName:kLastKnownLocation];
                NSLog(@"new loc");
            }
        }];
    }
    return self;
}

- (void)handleError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)persistArray:(NSArray *)array withFileName:(NSString *)fileName {
    [[NSKeyedArchiver archivedDataWithRootObject:array] writeToFile:[self filePathWithName:fileName] atomically:YES];
}

- (NSString *)filePathWithName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (NSArray *)persistedArrayWithFileName:(NSString *)fileName {
    NSData *data = [NSData dataWithContentsOfFile:[self filePathWithName:fileName]];
    if (!data) {
        return nil;
    }
    
    return [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
}

#pragma Properties

- (NSArray *)persistedArrivals {
    return [self persistedArrayWithFileName:kArrivalsFile];
}

- (NSArray *)persistedBuses {
    return [self persistedArrayWithFileName:kBusesFile];
}

- (NSArray *)persistedStops {
    return [self persistedArrayWithFileName:kStopsFile];
}

- (NSArray *)persistedAnnouncements {
    return [self persistedArrayWithFileName:kAnnouncementsFile];
}

- (CLLocation *)persistedLastKnownLocation {
    return (CLLocation *)[self persistedArrayWithFileName:kLastKnownLocation][0];
}

#pragma Fetch

- (void)fetchArrivalsWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchArrivalsWithSuccessBlock:^(NSArray *arrivals) {
        [self persistArray:arrivals withFileName:kArrivalsFile];
        self.arrivals = arrivals;
    } errorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
        [self handleError:error];
    }];
}

- (void)fetchBusesWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchBusesWithSuccessBlock:^(NSArray *buses) {
        [self persistArray:buses withFileName:kBusesFile];
        self.buses = buses;
        } errorBlock:^(NSError *error) {
          if (errorBlock) {
            errorBlock(error);
        };
        [self handleError:error];
    }];
}

- (void)fetchStopsWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchStopsWithSuccessBlock:^(NSArray *stops) {
        [self persistArray:stops withFileName:kStopsFile];
        self.stops = stops;
    } errorBlock:^(NSError *error) {
          if (errorBlock) {
            errorBlock(error);
        };
        [self handleError:error];
    }];
}

- (void)fetchAnnouncementsWithErrorBlock:(DataStoreErrorBlock)errorBlock {
    [self.networkingSession fetchAnnouncementsWithSuccessBlock:^(NSArray *announcements) {
        [self persistArray:announcements withFileName:kAnnouncementsFile];
        self.announcements = announcements;
    } errorBlock:^(NSError *error) {
          if (errorBlock) {
            errorBlock(error);
        };
        [self handleError:error];
    }];
}

@end
