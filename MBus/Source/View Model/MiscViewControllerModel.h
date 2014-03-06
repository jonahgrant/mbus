//
//  MiscViewControllerModel.h
//  MBus
//
//  Created by Jonah Grant on 2/27/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "ViewControllerModelBase.h"

typedef NS_ENUM(NSInteger, Cell) {
    CellAcknowledgements,
    CellSupport,
    CellContact,
    CellReview,
    CellAbout,
    CellMap,
    CellAnnouncements
};

typedef NS_ENUM(NSInteger, Section) {
    SectionMore,
    SectionContact,
    SectionMisc,
    SectionLegal
};

extern NSInteger NSIntegerForCell(Cell cell);
extern NSInteger NSIntegerForSection(Section section);

@interface MiscViewControllerModel : ViewControllerModelBase

@property (nonatomic, strong, readonly) NSArray *sections;
@property (nonatomic, strong, readonly) NSDictionary *cells;

@end
