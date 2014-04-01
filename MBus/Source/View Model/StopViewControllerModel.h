//
//  StopViewControllerModel.h
//  MBus
//
//  Created by Jonah Grant on 2/24/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "ViewControllerModelBase.h"

typedef NS_ENUM(NSInteger, Section) {
    SectionRoutes,
    SectionAddress,
    SectionMisc
};

typedef NS_ENUM(NSInteger, MiscCell) {
    MiscCellDirections,
    MiscCellStreetView
};

extern NSString * NSStringForSection(Section section);

@class Stop, Arrival;

@interface StopViewControllerModel : ViewControllerModelBase

@property (nonatomic, strong, readonly) Stop *stop;
@property (nonatomic, strong, readonly) NSArray *arrivalsServicingStop, *arrivalsServicingStopCellModels, *arrivalIDsServicingStop, *miscCells;

- (instancetype)initWithStop:(Stop *)stop;

- (NSString *)timeSinceRoutesRefresh;

@end
