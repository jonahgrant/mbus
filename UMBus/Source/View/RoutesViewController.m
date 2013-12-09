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

@interface RoutesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation RoutesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Routes";
    
    self.model = [[RoutesViewControllerModel alloc] init];
    [self fetchData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [RACObserve(self.model, arrivals) subscribeNext:^(NSArray *arrivals) {
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.model.arrivals.count;
            break;
        case 1:
            return 1;
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 1) {
        return 50;
    }
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ArrivalRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        Arrival *arrival = self.model.arrivals[indexPath.row];
        ArrivalRouteCellModel *arrivalCellModel = [[ArrivalRouteCellModel alloc] initWithArrival:arrival];
        cell.model = arrivalCellModel;
        
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
        cell.textLabel.text = @"Nearby stops";
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Select a route";
    }
    
    return nil;
}

#pragma UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:UMSequeArrivals sender:self];
    } else if (indexPath.section == 1) {
        // show nearby stops
    }
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:UMSequeArrivals]) {
        ArrivalsViewController *arrivals = (ArrivalsViewController *)segue.destinationViewController;
        Arrival *arrival = self.model.arrivals[[self.tableView indexPathForSelectedRow].row];
        arrivals.arrival = arrival;
    }
}

@end
