//
//  StopViewController.m
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "StopViewController.h"
#import "StopViewControllerModel.h"
#import "StopViewControllerTitleView.h"
#import "Stop.h"
#import "AddressCellModel.h"
#import "AddressCell.h"
#import "StreetViewController.h"
#import "StopArrivalCell.h"
#import "StopArrivalCellModel.h"
#import "UMSegueIdentifiers.h"
#import "RouteViewController.h"
#import "Constants.h"

@interface StopViewController ()

@property (nonatomic, strong, readwrite) StopViewControllerModel *model;
@property (nonatomic, strong, readwrite) NSIndexPath *activeIndexPath;

@end

@implementation StopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [[StopViewControllerModel alloc] initWithStop:self.stop];
    @weakify(self);
    self.model.dataUpdatedBlock = ^ {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    };
    //[self.model fetchData];
    
    self.navigationItem.titleView = [[StopViewControllerTitleView alloc] initWithStop:self.model.stop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetInterface];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionRoutes:
            return (self.model.arrivalsServicingStop.count == 0) ? 1 : self.model.arrivalsServicingStop.count;
        case SectionAddress:
            return 1;
        case SectionMisc:
            return self.model.miscCells.count;
        default:
            return 0;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionRoutes) {
        return 130.0f;
    } else if (indexPath.section == SectionAddress) {
        return 80.0f;
    } else if (indexPath.section == SectionMisc) {
        return 50.0f;
    }
    
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSStringForSection(section);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == SectionRoutes) {
        return [NSString stringWithFormat:@"Last updated %@", [self.model timeSinceRoutesRefresh]];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionRoutes) {
        if (self.model.arrivalsServicingStop.count == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneCell" forIndexPath:indexPath];
            
            cell.textLabel.text = @"NONE";
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else {
            StopArrivalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            StopArrivalCellModel *arrivalCellModel = self.model.arrivalsServicingStopCellModels[indexPath.row];
            cell.model = arrivalCellModel;
            
            return cell;
        }
    } else if (indexPath.section == SectionAddress) {
        AddressCellModel *cellModel = [[AddressCellModel alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:self.model.stop.coordinate.latitude
                                                                                                            longitude:self.model.stop.coordinate.longitude]
                                                                          stopID:self.model.stop.id];
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
        cell.model = cellModel;
        
        return cell;
    } else if (indexPath.section == SectionMisc) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
        cell.textLabel.text = self.model.miscCells[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
  
    return nil;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.activeIndexPath = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == SectionRoutes) {
        [self performSegueWithIdentifier:UMSegueRoute sender:self];
    } else if (indexPath.section == SectionAddress) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:
                                                                         @"http://maps.apple.com/?q=%f,%f",
                                                                         self.model.stop.coordinate.latitude,
                                                                         self.model.stop.coordinate.longitude]]];
    } else if (indexPath.section == SectionMisc) {
        if (indexPath.row == MiscCellDirections) {
            NSString *address = [NSString stringWithFormat:FORMATTED_APPLE_MAPS_DIRECTIONS, self.model.stop.coordinate.latitude, self.model.stop.coordinate.longitude];
            NSURL *url = [[NSURL alloc] initWithString:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL:url];
        } else if (indexPath.row == MiscCellStreetView) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                StreetViewController *controller = [[StreetViewController alloc] initWithCoordinate:self.model.stop.coordinate
                                                                                            heading:[self.model.stop.heading integerValue]
                                                                                              title:self.model.stop.humanName];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:navController animated:YES completion:NULL];
                });
            });
        }
    }
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:UMSegueRoute]) {
        Arrival *arrival = self.model.arrivalsServicingStop[self.activeIndexPath.row];
        RouteViewController *routeController = (RouteViewController *)segue.destinationViewController;
        routeController.arrival = arrival;
    }
}

@end