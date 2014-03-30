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
#import "AppAnnouncement.h"
#import "Constants.h"
#import "UMAdditions+UIFont.h"
#import "AppDelegate.h"
#import "Fare+UIColor.h"
#import "CGLMailHelper.h"
#import "WebViewController.h"

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
    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
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

- (void)refresh {
    [self.model fetchData];
    [[AppDelegate sharedInstance] fetchAppAnnouncements];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([AppDelegate sharedInstance].appAnnouncements.count > 0) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && [AppDelegate sharedInstance].appAnnouncements.count > 0) {
        return [AppDelegate sharedInstance].appAnnouncements.count;
    }
    
    else {
        return [DataStore sharedManager].announcements.count;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && [AppDelegate sharedInstance].appAnnouncements.count > 0) {
        return [self.model heightForAnnouncement:[AppDelegate sharedInstance].appAnnouncements[indexPath.row]
                                           width:self.view.frame.size.width
                                            font:[UIFont helveticaNeueWithWeight:TypeWeightNormal size:14]];
    }
    
    else {
        return [self.model heightForAnnouncement:[DataStore sharedManager].announcements[indexPath.row]
                                           width:self.view.frame.size.width
                                            font:[UIFont helveticaNeueWithWeight:TypeWeightNormal size:14]];
    }
    

    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((section == 1 && [AppDelegate sharedInstance].appAnnouncements.count > 0) || (section == 0 && [AppDelegate sharedInstance].appAnnouncements.count == 0)) {
        return self.model.headerString;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ((section == 1 && [AppDelegate sharedInstance].appAnnouncements.count > 0) || (section == 0 && [AppDelegate sharedInstance].appAnnouncements.count == 0)) {
        return self.model.footerString;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && [AppDelegate sharedInstance].appAnnouncements.count > 0) {
        static NSString *CellIdentifier = @"AppAnnouncementCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        AppAnnouncement *announcement = [AppDelegate sharedInstance].appAnnouncements[indexPath.row];
    
        cell.textLabel.text = announcement.text;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightNormal size:14];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = announcement.backgroundColor;
        
        UIView *sidebarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, CGRectGetHeight(cell.frame))];
        sidebarView.backgroundColor = announcement.color;
        [cell addSubview:sidebarView];
        
        return cell;
    }
    
    else {
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
    
    return nil;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AppAnnouncement *announcement = [AppDelegate sharedInstance].appAnnouncements[indexPath.row];
        SendEventWithLabel(@"tapped_app_announcement", announcement.tag);
        NSLog(@"tapped_app_announcement %@", announcement.tag);
        
        if (![announcement.action isEqualToString:@"none"]) {
            if ([announcement.action isEqualToString:@"email"]) {
                UIViewController *viewController = [CGLMailHelper mailViewControllerWithRecipients:@[announcement.actionDestination]
                                                                                           subject:@"A message sent from MBus"
                                                                                           message:announcement.actionBody
                                                                                            isHTML:NO
                                                                                    includeAppInfo:NO
                                                                                        completion:^(NSString *result, NSError *error) {
                                                                                            SendEventWithLabel(@"completed_app_announcement_action_mail", announcement.tag);
                                                                                        }];
                [self presentViewController:viewController animated:YES completion:NULL];
            } else if ([announcement.action isEqualToString:@"phone"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", announcement.actionDestination]]];
            } else if ([announcement.action isEqualToString:@"sms"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", announcement.actionDestination]]];
            } else if ([announcement.action isEqualToString:@"url"]) {
                WebViewController *viewController = [[WebViewController alloc] initWithURL:[NSURL URLWithString:announcement.actionDestination]];
                [self.navigationController pushViewController:viewController animated:YES];
            } else if ([announcement.action isEqualToString:@"native_url"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:announcement.actionDestination]];
            }
        }
    }
}

@end
