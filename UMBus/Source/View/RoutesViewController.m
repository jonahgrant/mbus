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

@interface RoutesViewController ()

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation RoutesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"University of Michigan";
    
    self.model = [[RoutesViewControllerModel alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self.model action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [RACObserve(self.model, routes) subscribeNext:^(NSArray *routes) {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setTintColor:nil];
    [self.tabBarController.tabBar setTintColor:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
            
            cell.textLabel.text = @"NO ROUTES OPERATING";
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneCell" forIndexPath:indexPath];
            
            cell.textLabel.text = @"Call Safe Rides";
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
        return @"Routes in service";
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.model footerString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.routes.count == 0) {
        if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://7346478000"]];
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
