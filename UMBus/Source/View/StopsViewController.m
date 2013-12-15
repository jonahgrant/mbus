//
//  StopsViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopsViewController.h"
#import "StopsViewControllerModel.h"
#import "StopViewController.h"
#import "DataStore.h"
#import "Stop.h"
#import "LocationManager.h"
#import "TTTLocationFormatter.h"
#import "StopCell.h"
#import "StopCellModel.h"
#import "SegueIdentifiers.h"

@interface StopsViewController ()

@end

@implementation StopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"University of Michigan";
    
    self.model = [[StopsViewControllerModel alloc] init];
    [self.model fetchStops];
    
    [RACObserve(self.model, sortedStops) subscribeNext:^(NSArray *stops) {
        if (stops) {
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setTintColor:nil];
    [self.tableView deselectRowAtIndexPath:[[self.tableView indexPathsForSelectedRows] firstObject] animated:YES];
}

#pragma UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.sortedStops.count == 0) {
        return 1;
    }
    
    return self.model.sortedStops.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Select a stop";
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.sortedStops.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneCell" forIndexPath:indexPath];
        
        cell.textLabel.text = @"NO STOPS BEING SERVICED";
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        StopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
        Stop *stop = self.model.sortedStops[indexPath.row];
        StopCellModel *stopCellModel = [[StopCellModel alloc] initWithStop:stop];
        cell.model = stopCellModel;
    
        return cell;
    }
    
    return nil;
}

#pragma UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:UMSegueStop sender:self];
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:UMSegueStop]) {
        StopViewController *controller = (StopViewController *)segue.destinationViewController;
        Stop *stop = self.model.sortedStops[[self.tableView indexPathForSelectedRow].row];
        controller.stop = stop;
    }
}

@end
