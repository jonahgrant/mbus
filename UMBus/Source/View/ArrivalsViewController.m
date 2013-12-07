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

@interface ArrivalsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *stops;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.stopsSortedByTimeOfArrival.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArrivalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ArrivalStop *stop = self.model.stopsSortedByTimeOfArrival[indexPath.row];
    ArrivalCellModel *arrivalCellModel = [[ArrivalCellModel alloc] initWithStop:stop];
    cell.model = arrivalCellModel;
    
    return cell;
}

@end
