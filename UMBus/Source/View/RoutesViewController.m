//
//  RoutesViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RoutesViewController.h"
#import "RoutesViewControllerModel.h"
#import "ArrivalRouteCell.h"
#import "ArrivalRouteCellModel.h"
#import "RouteViewController.h"
#import "Arrival.h"
#import "Constants.h"

@implementation RoutesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = kUniversityOfMichigan;
    
    self.model = [[RoutesViewControllerModel alloc] init];
    
    [self.refreshControl addTarget:self.model action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    
    [RACObserve(self.model, routes) subscribeNext:^(NSArray *routes) {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
    
    SendPage(@"RoutesViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setTintColor:nil];
    [self.tabBarController.tabBar setTintColor:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.routes.count == 0) {
        return 2;
    }
    
    return self.model.routes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.routes.count == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneCell" forIndexPath:indexPath];
            
            cell.textLabel.text = kErrorNoRoutesInService;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneCell" forIndexPath:indexPath];
            
            cell.textLabel.text = kCallSafeRides;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
    } else {
        ArrivalRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        Arrival *arrival = self.model.routes[indexPath.row];
        ArrivalRouteCellModel *arrivalCellModel = [[ArrivalRouteCellModel alloc] initWithArrival:arrival];
        cell.model = arrivalCellModel;
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kTableHeaderRoutesInService;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.model footerString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.routes.count == 0) {
        if (indexPath.row == 1) {
            SendEvent(@"called_safe_rides");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kSafeRidesTel]];
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        }
    } else {
        [self performSegueWithIdentifier:UMSegueRoute sender:self];
    }
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:UMSegueRoute]) {
        Arrival *arrival = self.model.routes[[self.tableView indexPathForSelectedRow].row];
        RouteViewController *routeController = (RouteViewController *)segue.destinationViewController;
        routeController.arrival = arrival;
    }
}

@end
