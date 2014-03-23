//
//  StopsViewController.m
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "StopsViewController.h"
#import "StopsViewControllerModel.h"
#import "DataStore.h"
#import "StopCell.h"
#import "StopCellModel.h"
#import "StopViewController.h"
#import "StopViewControllerModel.h"
#import "Stop.h"
#import "AllStopsViewController.h"
#import "UMAdditions+UIFont.h"

static CGFloat STOP_CELL_HEIGHT = 100.0f;
static CGFloat ALL_STOPS_CELL_HEIGHT = 80.0f;

static NSInteger MAXIMUM_STOPS = 5; // this represents the amount of stops that are shown
static NSInteger ALL_STOPS_CELL = 5;

@interface StopsViewController ()

@property (strong, nonatomic) StopsViewControllerModel *model;

@end

@implementation StopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[StopsViewControllerModel alloc] init];
    @weakify(self);
    self.model.dataUpdatedBlock = ^ {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    };
    [self.model fetchData];
    
    [self.refreshControl addTarget:self.model action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetInterface];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.hasAnnouncements ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.hasAnnouncements && section == 0) {
        return 1;
    } else {
        return (self.model.stops.count > MAXIMUM_STOPS) ? MAXIMUM_STOPS + 1 : self.model.stops.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.hasAnnouncements && indexPath.section == 0) {
        return 80.0f;
    }
    
    return (self.model.stops.count > MAXIMUM_STOPS && indexPath.row == ALL_STOPS_CELL) ? ALL_STOPS_CELL_HEIGHT : STOP_CELL_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.model.hasAnnouncements && section == 0) {
        return nil;
    }
    
    return self.model.sectionHeaderText;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.hasAnnouncements && indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementsCell" forIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor colorWithRed:0.941177 green:0.678431 blue:0.305882 alpha:1.0000];
        cell.textLabel.text = @"Attention";
        cell.textLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightNormal size:18.0f];
        cell.detailTextLabel.text = self.model.announcementsCellText;
        cell.detailTextLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightLight size:14.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *sidebarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, CGRectGetHeight(cell.frame))];
        sidebarView.backgroundColor = [UIColor colorWithRed:0.941177 green:0.678431 blue:0.305882 alpha:1.0000];
        [cell addSubview:sidebarView];
        
        return cell;
    } else {
        if (self.model.stops.count > MAXIMUM_STOPS && indexPath.row == ALL_STOPS_CELL) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllStopsCell" forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:FORMATTED_MORE_STOPS_CELL_TEXT, self.model.stops.count - 5];
            cell.textLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightLight size:18.0f];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        } else {
            StopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StopCell" forIndexPath:indexPath];
            cell.model = self.model.stopCellModels[indexPath.row];
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.hasAnnouncements && indexPath.section == 0) {
        [self performSegueWithIdentifier:UMSegueAnnouncements sender:self];
    } else if (self.model.stops.count > MAXIMUM_STOPS && indexPath.row == ALL_STOPS_CELL) {
        [self performSegueWithIdentifier:UMSegueAllStops sender:self];
    } else {
        [self performSegueWithIdentifier:UMSegueStop sender:self];
    }
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:UMSegueStop]) {
        StopViewController *controller = (StopViewController *)segue.destinationViewController;
        controller.stop = self.model.stops[[self.tableView indexPathForSelectedRow].row];
    } else if ([segue.identifier isEqualToString:UMSegueAllStops]) {
        AllStopsViewController *controller = (AllStopsViewController *)segue.destinationViewController;
        controller.model = self.model;
    }
}

@end
