//
//  StopViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopViewController.h"
#import "StopViewControllerModel.h"
#import "StopViewControllerTitleView.h"
#import "Stop.h"
#import "StopArrivalCell.h"
#import "StopArrivalCellModel.h"
#import "AddressCell.h"
#import "AddressCellModel.h"
#import "StreetViewController.h"
#import "GCBActionSheet.h"
#import "Arrival.h"
#import "Stop.h"
#import "NotificationManager.h"
#import "DataStore.h"

@interface StopViewController ()

@property (strong, nonatomic) NSArray *cells;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation StopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [[StopViewControllerModel alloc] initWithStop:self.stop];
    self.title = self.model.stop.humanName;
    
    self.cells = @[@"Directions to stop", @"Street view"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self.model action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [RACObserve(self.model, arrivalsServicingStop) subscribeNext:^(NSArray *arrivals) {
        if (arrivals) {
            if (self.refreshControl.isRefreshing) [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
    
    self.navigationItem.titleView = [[StopViewControllerTitleView alloc] initWithStop:self.model.stop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setTintColor:nil];
    [self.navigationController.navigationBar setTintColor:nil];
    [self.tableView deselectRowAtIndexPath:[[self.tableView indexPathsForSelectedRows] firstObject] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (self.model.arrivalsServicingStop.count == 0) {
                return 1;
            }
            
            return self.model.arrivalsServicingStop.count;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return self.cells.count;
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    } else if (indexPath.section == 1) {
        return 80;
    }
    
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Routes servicing this stop";
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return [NSString stringWithFormat:@"Last updated %@", [[DataStore sharedManager] arrivalsTimestamp]];
    }
    
    if (section == 2) {
        return @"The system behind MBus is under development.  Riders are encouraged to use it, but reliable and accurate information is not garunteed.";
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.model.arrivalsServicingStop.count == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneCell" forIndexPath:indexPath];
            
            cell.textLabel.text = @"NONE";
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else {
            StopArrivalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
            Arrival *arrival = self.model.arrivalsServicingStop[indexPath.row];
            StopArrivalCellModel *arrivalCellModel = [[StopArrivalCellModel alloc] initWithArrival:arrival stop:self.model.stop];
            cell.model = arrivalCellModel;
            
            return cell;
        }
    } else if (indexPath.section == 1) {
        AddressCellModel *addressCellModel = [[AddressCellModel alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:self.model.stop.coordinate.latitude
                                                                                                                   longitude:self.model.stop.coordinate.longitude]];
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
        cell.model = addressCellModel;
        
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
        cell.textLabel.text = self.cells[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        
        return cell;
    }
    
    return nil;
}

#pragma UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        
        Arrival *arrival = self.model.arrivalsServicingStop[indexPath.row];

        GCBActionSheet *actionSheet = [[GCBActionSheet alloc] initWithTitle:arrival.name delegate:nil];
        [actionSheet addButtonWithTitle:@"Notify before arrival" handler:^ {
            NotificationManager *notificationManager = [[NotificationManager alloc] init];
            [notificationManager scheduleNotificationWithFireDate:[self.model firstArrivalDateForArrival:arrival]
                                                          message:[NSString stringWithFormat:@"The %@ bus is arriving at %@ soon!", arrival.name, self.model.stop.humanName]];
        }];
        [actionSheet addButtonWithTitle:@"See route" handler:^ {
            [self performSegueWithIdentifier:UMSegueRoute sender:self];
        }];
        [actionSheet addCancelButtonWithTitle:@"Dismiss" handler:NULL];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            NSString *address = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=Posizione attuale", self.model.stop.coordinate.latitude, self.model.stop.coordinate.longitude];
            NSURL *url = [[NSURL alloc] initWithString:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL:url];
        }
        
        if (indexPath.row == 1) {
            StreetViewController *controller = [[StreetViewController alloc] initWithStop:self.model.stop];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navController animated:YES completion:NULL];
        }
    }
}


@end
