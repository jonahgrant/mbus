//
//  StopsViewControllerModel.h
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "ViewControllerModelBase.h"

@interface StopsViewControllerModel : ViewControllerModelBase

@property (nonatomic, strong, readonly) NSArray *stops, *stopCellModels;
@property (nonatomic, copy, readonly) NSString *sectionHeaderText, *announcementsCellText;
@property (nonatomic, readonly, getter = hasAnnouncements) BOOL announcements;

- (void)reloadData;

@end
