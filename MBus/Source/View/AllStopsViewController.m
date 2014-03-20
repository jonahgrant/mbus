//
//  AllStopsViewController.m
//  MBus
//
//  Created by Jonah Grant on 2/25/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "AllStopsViewController.h"
#import "StopsViewControllerModel.h"
#import "StopCell.h"
#import "StopViewController.h"
#import "StopViewControllerModel.h"
#import "Constants.h"

static CGFloat const STOP_CELL_HEIGHT = 100.0f;

@interface AllStopsViewController ()

@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation AllStopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // this allows our UISearchDisplayController's searchBar property to maintain
    // it's translucent background.  If FALSE, it would be transparent.
    //self.navigationController.navigationBar.translucent = YES;

    @weakify(self);
    self.model.dataUpdatedBlock = ^ {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetInterface];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow]
                                                                       animated:YES];
}

#pragma mark - UISearchDisplayController

- (void)searchDisplayControllerDidBeginSearch {
    SendEvent(ANALYTICS_BEGAN_STOPS_SEARCH);
}

- (void)searchDisplayControllerDidEndSearch {
    SendEvent(ANALYTICS_ENDED_STOPS_SEARCH);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(humanName contains[c] %@) OR (uniqueName contains[c] %@)", searchString, searchString];
    self.searchResults = [self.model.stops filteredArrayUsingPredicate:predicate];
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.model.stops.count;
    } else {
        return self.searchResults.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return STOP_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StopCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StopCell"];
    
    if (tableView == self.tableView) {
        cell.model = self.model.stopCellModels[indexPath.row];
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.model = self.model.stopCellModels[[self.model.stops indexOfObject:self.searchResults[indexPath.row]]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:UMSegueStop sender:self];
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:UMSegueStop]) {
        StopViewController *controller = (StopViewController *)segue.destinationViewController;
        if ([self.tableView indexPathForSelectedRow]) {
            controller.stop = self.model.stops[[self.tableView indexPathForSelectedRow].row];
        } else {
            controller.stop = self.searchResults[[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row];
        }
    }
}

@end
