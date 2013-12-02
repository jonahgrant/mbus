//
//  AnnouncementCellModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AnnouncementCellModel.h"
#import "Announcement.h"

@implementation AnnouncementCellModel

- (instancetype)initWithAnnouncement:(Announcement *)announcement {
    if (self = [super init]) {
        _announcement = announcement;
    }
    return self;
}

@end
