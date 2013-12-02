//
//  AnnoucementsViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AnnoucementsViewController.h"
#import "AnnouncementsViewControllerModel.h"
#import "Announcement.h"
#import "AnnouncementCell.h"
#import "AnnouncementCellModel.h"

@interface AnnoucementsViewController ()

@end

@implementation AnnoucementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Announcements";
    
    _model = [[AnnouncementsViewControllerModel alloc] init];
    [_model fetchAnnouncements];
    
    [RACObserve(self, model.announcements) subscribeNext:^(NSArray *announcements) {
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.announcements.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    Announcement *announcement = (Announcement *)_model.announcements[indexPath.row];
    return ([announcement.text boundingRectWithSize:CGSizeMake(320, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:15]}
                                            context:nil].size.height + 50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Announcement *announcement = (Announcement *)_model.announcements[indexPath.row];
    AnnouncementCellModel *announcementModel = [[AnnouncementCellModel alloc] initWithAnnouncement:announcement];
    cell.model = announcementModel;
    
    return cell;
}

@end
