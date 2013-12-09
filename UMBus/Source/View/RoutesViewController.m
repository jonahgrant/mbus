//
//  RoutesViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RoutesViewController.h"
#import "RoutesViewControllerModel.h"
#import "ArrivalRouteCell.h"
#import "ArrivalRouteCellModel.h"
#import "Arrival.h"
#import "SegueIdentifiers.h"
#import "ArrivalsViewController.h"
#import "DataStore.h"

@interface RoutesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation RoutesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"University of Michigan";
    
    self.model = [[RoutesViewControllerModel alloc] init];
    [self fetchData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [RACObserve([DataStore sharedManager], arrivals) subscribeNext:^(NSArray *arrivals) {
        if (arrivals) {
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
    
    [RACObserve(self.model, fetchError) subscribeNext:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[[self.tableView indexPathsForSelectedRows] firstObject] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setTintColor:nil];
    [self.tabBarController.tabBar setTintColor:nil];
}

- (void)fetchData {
    [self.model fetchArrivals];
}

#pragma UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([DataStore sharedManager].arrivals.count == 0) {
        return 1;
    }
    
    return [DataStore sharedManager].arrivals.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([DataStore sharedManager].arrivals.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneCell" forIndexPath:indexPath];
        
        cell.textLabel.text = @"NO ROUTES OPERATING";
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        ArrivalRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        Arrival *arrival = [DataStore sharedManager].arrivals[indexPath.row];
        ArrivalRouteCellModel *arrivalCellModel = [[ArrivalRouteCellModel alloc] initWithArrival:arrival];
        cell.model = arrivalCellModel;
        
        return cell;
    }
 }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Select a route";
    }
    
    return nil;
}

#pragma UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![DataStore sharedManager].arrivals.count == 0) {
        [self performSegueWithIdentifier:UMSequeArrivals sender:self];
    }
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:UMSequeArrivals]) {
        ArrivalsViewController *arrivals = (ArrivalsViewController *)segue.destinationViewController;
        Arrival *arrival = [DataStore sharedManager].arrivals[[self.tableView indexPathForSelectedRow].row];
        arrivals.arrival = arrival;
    }
}

@end
