//
//  AnnouncementsViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouncementsViewControllerModel : NSObject

@property (strong, nonatomic) NSArray *announcements;

- (void)fetchAnnouncements;

@end
