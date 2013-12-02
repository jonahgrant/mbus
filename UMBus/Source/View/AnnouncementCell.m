//
//  AnnouncementCell.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AnnouncementCell.h"
#import "AnnouncementCellModel.h"
#import "Announcement.h"

@interface AnnouncementCell ()

@property (nonatomic, strong) IBOutlet UILabel *announcementLabel;

@end

@implementation AnnouncementCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        RAC(self, announcementLabel.text) = RACObserve(self, model.announcement.text);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
