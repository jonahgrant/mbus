//
//  RouteViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RouteViewController.h"
#import "RouteViewControllerModel.h"
#import "RouteMapViewController.h"
#import "Arrival.h"
#import "ArrivalCell.h"
#import "ArrivalCellModel.h"
#import "HexColor.h"
#import "DataStore.h"
#import "Constants.h"
#import "UMSegueIdentifiers.h"

@interface RouteViewController ()

@property (strong, nonatomic) NSArray *informationCells;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    RAC(self, title) = RACObserve(self.arrival, name);
    
    self.model = [[RouteViewControllerModel alloc] initWithArrival:self.arrival];
    self.informationCells = @[@"Map"];
    
    [self.refreshControl addTarget:self.model action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];

    [[RACObserve(self.model, sortedStops) filter:^BOOL(NSArray *stops) {
        return (stops.count > 0);
    }] subscribeNext:^(NSArray *stops) {
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setInterfaceWithColor:[UIColor colorWithHexString:self.arrival.busRouteColor]];
    
    [self.tableView deselectRowAtIndexPath:[[self.tableView indexPathsForSelectedRows] firstObject] animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
            return self.model.sortedStops.count;
        default:
            break;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return ROUTE_INFORMATION;
        case 1:
            return [NSString stringWithFormat:@"%lu Stops", (unsigned long)self.model.sortedStops.count];
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
            return 100;
        default:
            break;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return [self.model footerString];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = self.informationCells[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else if (indexPath.section == 1) {
        ArrivalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StopCell" forIndexPath:indexPath];
        
        ArrivalStop *stop = self.model.sortedStops[indexPath.row];
        ArrivalCellModel *arrivalCellModel = [[ArrivalCellModel alloc] initWithStop:stop forArrival:self.model.arrival];
        cell.model = arrivalCellModel;
        cell.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(tableView.bounds), -100, 0); // hide the seperator
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SendEvent(ANALYTICS_VIEW_ROUTE_MAP);
        
        [self performSegueWithIdentifier:UMSegueRouteMap sender:self];
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
