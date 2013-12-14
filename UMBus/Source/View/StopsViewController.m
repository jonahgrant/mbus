//
//  StopsViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopsViewController.h"
#import "StopsViewControllerModel.h"
#import "DataStore.h"
#import "Stop.h"
#import "LocationManager.h"
#import "TTTLocationFormatter.h"
#import "StopCell.h"
#import "StopCellModel.h"

@interface StopsViewController ()

@end

@implementation StopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Stops";
    
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
}

#pragma UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    StopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Stop *stop = self.model.sortedStops[indexPath.row];
    StopCellModel *stopCellModel = [[StopCellModel alloc] initWithStop:stop];
    cell.model = stopCellModel;
    
    return cell;
}

#pragma UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
