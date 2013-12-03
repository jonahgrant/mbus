//
//  AnnouncementsViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AnnouncementsViewControllerModel.h"
#import "UMNetworkingSession.h"

@interface AnnouncementsViewControllerModel ()

@property (strong, nonatomic) UMNetworkingSession *session;

@end

@implementation AnnouncementsViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        _session = [[UMNetworkingSession alloc] init];
    }
    return self;
}

- (void)fetchAnnouncements {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_session fetchAnnouncementsWithSuccessBlock:^(NSArray *announcements) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.announcements = announcements;
    } errorBlock:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

@end
