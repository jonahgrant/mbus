//
//  AnnouncementsViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AnnouncementsViewController.h"
#import "AnnouncementsViewControllerModel.h"
#import "DataStore.h"
#import "Announcement.h"
#import "Constants.h"
#import "UMAdditions+UIFont.h"

@implementation AnnouncementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [[AnnouncementsViewControllerModel alloc] init];
    @weakify(self);
    self.model.dataUpdatedBlock = ^ {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    };
    
    [self.refreshControl addTarget:self.model action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self resetInterface];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setTintColor:nil];
    [self.tabBarController.tabBar setTintColor:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DataStore sharedManager].announcements.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.model heightForAnnouncement:[DataStore sharedManager].announcements[indexPath.row]
                                       width:self.view.frame.size.width
                                        font:[UIFont helveticaNeueWithWeight:TypeWeightNormal size:14]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.model.headerString;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return self.model.footerString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AnnouncementCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Announcement *announcement = [DataStore sharedManager].announcements[indexPath.row];
    
    cell.textLabel.text = announcement.text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightNormal size:14];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *sidebarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, CGRectGetHeight(cell.frame))];
    sidebarView.backgroundColor = announcement.color;
    [cell addSubview:sidebarView];
    
    return cell;
}

@end
