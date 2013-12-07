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
    return self.model.stopsSortedByTimeOfArrival.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ArrivalStop *stop = self.model.stopsSortedByTimeOfArrival[indexPath.section];
    cell.textLabel.text = stop.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Bus 1 arriving in %@. Bus 2 arriving in %@.",
                                 [self.model mmssForTimeInterval:stop.timeOfArrival],
                                 [self.model mmssForTimeInterval:stop.timeOfArrival2]];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
