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
        self.announcements = self.announcements;
    }];
}

- (NSString *)timeSinceLastRefresh {
    if (![[DataStore sharedManager] arrivalsTimestamp]) {
        return @"never";
    }
    
    return [self.timeIntervalFormatter stringForTimeInterval:[[[DataStore sharedManager] arrivalsTimestamp] timeIntervalSinceDate:[NSDate date]]];
}

- (NSString *)footerString {
    return [NSString stringWithFormat:@"Last updated %@", [self timeSinceLastRefresh]];
}

- (NSString *)headerString {
    return [NSString stringWithFormat:@"%i announcements", [DataStore sharedManager].announcements.count];
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
