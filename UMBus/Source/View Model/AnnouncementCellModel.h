//
//  AnnouncementCellModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Announcement;

@interface AnnouncementCellModel : NSObject

@property (strong, nonatomic) Announcement *announcement;

- (instancetype)initWithAnnouncement:(Announcement *)announcement;

@end
