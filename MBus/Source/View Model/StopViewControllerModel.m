//
//  StopViewControllerModel.m
//  MBus
//
//  Created by Jonah Grant on 2/24/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "StopViewControllerModel.h"
#import "DataStore.h"
#import "TTTTimeIntervalFormatter.h"
#import "Constants.h"
#import "Arrival.h"
#import "ArrivalStop.h"
#import "Stop.h"
#import "StopArrivalCellModel.h"

NSString * NSStringForSection(Section section) {
    switch (section) {
        case SectionRoutes:
            return @"Routes servicing this stop";
        case SectionAddress:
            return nil;
        case SectionMisc:
            return nil;
        default:
            return nil;
    }
}

NSString * NSStringForMiscCell(MiscCell cell) {
    switch (cell) {
        case MiscCellDirections:
            return @"Directions to stop";
        case MiscCellStreetView:
            return @"Street view";
        default:
            return nil;
    }
}

@interface StopViewControllerModel ()

@property (nonatomic, strong, readwrite) Stop *stop;
@property (nonatomic, strong, readwrite) NSArray *arrivalsServicingStop, *arrivalsServicingStopCellModels, *arrivalIDsServicingStop, *miscCells;
@property (nonatomic, strong, readwrite) TTTTimeIntervalFormatter *timeIntervalFormatter;

- (void)updateArrivals;

@end

@implementation StopViewControllerModel

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        self.stop = stop;
        self.miscCells = @[NSStringForMiscCell(MiscCellDirections), NSStringForMiscCell(MiscCellStreetView)];
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
        [RACObserve([DataStore sharedManager], arrivals) subscribeNext:^(NSArray *arrivals) {
            [self updateArrivals];
        }];
        
        [[RACObserve(self, arrivalsServicingStopCellModels) filter:^BOOL(NSDictionary *models) {
            return (models.count > 0 && self.dataUpdatedBlock);
        }] subscribeNext:^(NSDictionary *models) {
            self.dataUpdatedBlock();
        }];
    }
    return self;
}


#pragma mark - ViewControllerModelBase

- (void)fetchData {
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:^(NSError *error) {
        self.dataUpdatedBlock();
    }];
}

#pragma mark - Private

- (void)updateArrivals {
    NSArray *arrivals = [[DataStore sharedManager] arrivalsContainingStopName:self.stop.uniqueName];
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *IDsMutableArray = [NSMutableArray array];
    
    for (Arrival *arrival in arrivals) {
        StopArrivalCellModel *arrivalCellModel = [[StopArrivalCellModel alloc] initWithArrival:arrival stop:self.stop];
        [mutableArray addObject:arrivalCellModel];
        [IDsMutableArray addObject:arrival.id];
    }
    
    self.arrivalsServicingStopCellModels = mutableArray;
    self.arrivalsServicingStop = arrivals;
    self.arrivalIDsServicingStop = IDsMutableArray;
}

- (ArrivalStop *)arrivalStopForArrival:(Arrival *)arrival {
    return [[DataStore sharedManager] arrivalStopForRouteID:arrival.id stopName:self.stop.uniqueName];
}

- (NSTimeInterval)firstArrivalTimeIntervalForArrival:(Arrival *)arrival {
    ArrivalStop *arrivalStop = [self arrivalStopForArrival:arrival];
    
    BOOL hasBus1 = [[DataStore sharedManager] arrivalHasBus1WithArrivalID:arrival.id];
    BOOL hasBus2 = [[DataStore sharedManager] arrivalHasBus2WithArrivalID:arrival.id];
    
    NSTimeInterval toa = 0;
    if (hasBus1 && hasBus2) {
        toa = (arrivalStop.timeOfArrival >= arrivalStop.timeOfArrival2) ? arrivalStop.timeOfArrival2 : arrivalStop.timeOfArrival;
    } else if (hasBus1 && !hasBus2) {
        toa = arrivalStop.timeOfArrival;
    } else if (!hasBus1 && hasBus2) {
        toa = arrivalStop.timeOfArrival2;
    } else {
        toa = -1;
    }
    
    return toa;
}

#pragma mark - Public

- (NSDate *)firstArrivalDateForArrival:(Arrival *)arrival {
    NSTimeInterval timeInterval = [self firstArrivalTimeIntervalForArrival:arrival];
    if (timeInterval == -1) {
        return nil;
    }
    
    // notify two minutes before the bus arrives, if over five minutes remaining
    return [NSDate dateWithTimeInterval:(timeInterval > 300) ? timeInterval - 120 : timeInterval
                              sinceDate:[[DataStore sharedManager] arrivalsTimestamp]];
}

- (NSString *)timeSinceRoutesRefresh {
    return (![[DataStore sharedManager] arrivalsTimestamp]) ?
    NEVER :
    [self.timeIntervalFormatter stringForTimeInterval:[[[DataStore sharedManager] arrivalsTimestamp] timeIntervalSinceDate:[NSDate date]]];
}

@end
