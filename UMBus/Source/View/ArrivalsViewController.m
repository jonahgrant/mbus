//
//  ArrivalsViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalsViewController.h"
#import "ArrivalsViewControllerModel.h"
#import "Arrival.h"
#import "ArrivalStop.h"
#import "ArrivalCell.h"
#import "ArrivalCellModel.h"
#import "HexColor.h"
#import "DataStore.h"
#import "RouteMapViewController.h"

@interface ArrivalsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *stops, *informationCells;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ArrivalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.arrival.name;
    
    self.model = [[ArrivalsViewControllerModel alloc] initWithArrival:self.arrival];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.informationCells = @[@"Map"];
    
    [RACObserve(self.model, stopsSortedByTimeOfArrival) subscribeNext:^(NSArray *stops) {
        if (stops) {
            [self.tableView reloadData];
        }
    }];
    
    [RACObserve([DataStore sharedManager], arrivals) subscribeNext:^(NSArray *arrivals) {
        if (arrivals) {
            [self.refreshControl endRefreshing];
            [self.model setArrival:[[DataStore sharedManager] arrivalForID:self.arrival.id]];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:self.arrival.busRouteColor]];
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithHexString:self.arrival.busRouteColor]];
}

- (void)refresh {
    [[DataStore sharedManager] fetchArrivals];
}

#pragma UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.informationCells.count;
            break;
        case 1:
            return self.model.stopsSortedByTimeOfArrival.count;
        default:
            break;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Route information";
        case 1:
            return @"Stops";
            break;
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 120;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = self.informationCells[indexPath.row];
        return cell;
    }
    
    if (indexPath.section == 1) {
        ArrivalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StopCell" forIndexPath:indexPath];
        
        ArrivalStop *stop = self.model.stopsSortedByTimeOfArrival[indexPath.row];
        ArrivalCellModel *arrivalCellModel = [[ArrivalCellModel alloc] initWithStop:stop];
        cell.model = arrivalCellModel;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:UMSegueRouteMap sender:self];
    }
    
    if (indexPath.section == 1) {
        
    }
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:UMSegueRouteMap]) {
        RouteMapViewController *routeMap = (RouteMapViewController *)segue.destinationViewController;
        routeMap.arrival = self.model.arrival;
    }
}

@end
