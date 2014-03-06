//
//  StopsViewController.m
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "StopsViewController.h"
#import "StopsViewControllerModel.h"
#import "DataStore.h"
#import "StopCell.h"
#import "StopCellModel.h"
#import "StopViewController.h"
#import "StopViewControllerModel.h"
#import "UMSegueIdentifiers.h"
#import "Stop.h"
#import "AllStopsViewController.h"
#import "UMAdditions+UIFont.h"
#import "Constants.h"

static CGFloat STOP_CELL_HEIGHT = 100.0f;
static CGFloat ALL_STOPS_CELL_HEIGHT = 80.0f;

static NSInteger MAXIMUM_STOPS = 5;
static NSInteger ALL_STOPS_CELL = 5;

@interface StopsViewController ()

@property (strong, nonatomic) StopsViewControllerModel *model;

@end

@implementation StopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[StopsViewControllerModel alloc] init];
    @weakify(self);
    self.model.dataUpdatedBlock = ^ {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    };
    [self.model fetchData];
    
    [self.refreshControl addTarget:self.model action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetInterface];
        
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.model.stops.count > MAXIMUM_STOPS) ? MAXIMUM_STOPS + 1 : self.model.stops.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.stops.count > MAXIMUM_STOPS && indexPath.row == ALL_STOPS_CELL) {
        return ALL_STOPS_CELL_HEIGHT;
    }
    
    return STOP_CELL_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.model.sectionHeaderText;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.stops.count > MAXIMUM_STOPS && indexPath.row == ALL_STOPS_CELL) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllStopsCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:FORMATTED_MORE_STOPS_CELL_TEXT, self.model.stops.count - 5];
        cell.textLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightLight size:18.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else {
        StopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StopCell" forIndexPath:indexPath];
        cell.model = self.model.stopCellModels[indexPath.row];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.stops.count > MAXIMUM_STOPS && indexPath.row == ALL_STOPS_CELL) {
        [self performSegueWithIdentifier:UMSegueAllStops sender:self];
    } else {
        [self performSegueWithIdentifier:UMSegueStop sender:self];
    }
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:UMSegueStop]) {
        StopViewController *controller = (StopViewController *)segue.destinationViewController;
        controller.stop = self.model.stops[[self.tableView indexPathForSelectedRow].row];
    } else if ([segue.identifier isEqualToString:UMSegueAllStops]) {
        AllStopsViewController *controller = (AllStopsViewController *)segue.destinationViewController;
        controller.model = self.model;
    }
}

@end
