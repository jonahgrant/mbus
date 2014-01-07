//
//  AnnouncementsViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AnnouncementsViewControllerModel.h"
#import "TTTTimeIntervalFormatter.h"
#import "DataStore.h"
#import "Announcement.h"
#import "Constants.h"

@interface AnnouncementsViewControllerModel ()

@property (strong, nonatomic) TTTTimeIntervalFormatter *timeIntervalFormatter;

@end

@implementation AnnouncementsViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
        [RACObserve([DataStore sharedManager], announcements) subscribeNext:^(NSArray *announcements) {
            self.announcements = announcements;
        }];
    }
    return self;
}

- (void)fetchData {
    [[DataStore sharedManager] fetchAnnouncementsWithErrorBlock:^(NSError *error) {
        // this will force the UITableView to reload it's data, showing that no announcements are available
        self.announcements = self.announcements;
    }];
}

- (NSString *)timeSinceLastRefresh {
    if (![[DataStore sharedManager] arrivalsTimestamp]) {
        return kNever;
    }
    
    return [self.timeIntervalFormatter stringForTimeInterval:[[[DataStore sharedManager] announcementsTimestamp] timeIntervalSinceDate:[NSDate date]]];
}

- (NSString *)footerString {
    return [NSString stringWithFormat:kFormattedStringLastUpdated, [self timeSinceLastRefresh]];
}

- (NSString *)headerString {
    return [NSString stringWithFormat:kFormattedStringXAnnouncements, [DataStore sharedManager].announcements.count];
}

- (CGFloat)heightForAnnouncement:(Announcement *)announcement width:(CGFloat)width font:(UIFont *)font {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:announcement.text];
    [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [announcement.text length])];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(250.0, CGFLOAT_MAX)
                                        options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        context:nil];
    return rect.size.height + 30;
}

@end
