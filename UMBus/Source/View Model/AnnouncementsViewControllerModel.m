//
//  AnnouncementsViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/8/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AnnouncementsViewControllerModel.h"
#import "DataStore.h"

@implementation AnnouncementsViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
    
    }
    return self;
}

- (void)fetchAnnouncements {
    [[DataStore sharedManager] fetchAnnouncements];
}
@end
