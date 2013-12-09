//
//  AnnouncementsViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/8/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouncementsViewControllerModel : NSObject

@property (strong, nonatomic) NSError *fetchAnnouncementsError;

- (void)fetchAnnouncements;

@end
