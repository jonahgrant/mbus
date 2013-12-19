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
#import "StreetViewController.h"

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
            [self.refreshControl endRefreshing];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.model.arrivalsServicingStop.count;
            break;
        case 1:
            return self.cells.count;
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
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
    if (section == 1) {
        return @"The system behind MBus is under development.  Riders are encouraged to use it, but reliable and accurate information is not garunteed.";
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StopArrivalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        Arrival *arrival = self.model.arrivalsServicingStop[indexPath.row];
        StopArrivalCellModel *arrivalCellModel = [[StopArrivalCellModel alloc] initWithArrival:arrival stop:self.model.stop];
        cell.model = arrivalCellModel;
        
        return cell;
    }
    
    else if (indexPath.section == 1) {
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
        //[self performSegueWithIdentifier:UMSequeArrivals sender:self];
    }
    
    if (indexPath.section == 1) {
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
