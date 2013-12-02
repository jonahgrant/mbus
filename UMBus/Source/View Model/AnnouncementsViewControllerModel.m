//
//  AnnouncementsViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AnnouncementsViewControllerModel.h"
#import "BusSession.h"

@interface AnnouncementsViewControllerModel ()

@property (strong, nonatomic) BusSession *session;

@end

@implementation AnnouncementsViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        _session = [[BusSession alloc] init];
    }
    return self;
}

- (void)fetchAnnouncements {
    [_session fetchAnnouncementsWithSuccessBlock:^(NSArray *announcements) {
        self.announcements = announcements;
    } errorBlock:NULL];
}

@end
