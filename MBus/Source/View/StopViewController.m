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
#import "RouteViewController.h"
#import "UMAdditions+UIFont.h"
#import "Arrival.h"
#import "NotificationManager.h"
#import "MapViewController.h"
#import "GCBActionSheet.h"
#import "NotifyViewController.h"

@interface StopViewController ()

@property (nonatomic, strong, readwrite) StopViewControllerModel *model;
@property (nonatomic, strong, readwrite) NSIndexPath *activeIndexPath;
@property (nonatomic) AddressCell *addressCell;
@property (nonatomic) BOOL shouldPurgeMap;

@end

@implementation StopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshControl];
    
    self.model = [[StopViewControllerModel alloc] initWithStop:self.stop];
    @weakify(self);
    self.model.dataUpdatedBlock = ^ {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        });
    };
    
    [refreshControl addTarget:self.model action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = [[StopViewControllerTitleView alloc] initWithStop:self.model.stop];
    
    NSString *stop = [NSString stringWithFormat:@"%@ (%@)", self.model.stop.humanName, self.model.stop.uniqueName];
    SendEventWithLabel(@"viewed_stop", stop);
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.shouldPurgeMap = YES;
    
    [self.tableView reloadData];
    [self resetInterface];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if (self.shouldPurgeMap && self.parentViewController == nil) {
        [self.addressCell purgeMapMemory];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self.addressCell purgeMapMemory];
}

- (void)presentRouteActionChooserForArrival:(Arrival *)arrival {
    GCBActionSheet *actionSheet = [[GCBActionSheet alloc] initWithTitle:arrival.name delegate:nil];
    
    [actionSheet addButtonWithTitle:@"View route" handler:^ {
        SendEvent(ANALYTICS_STOP_ARRIVAL_VIEW_ROUTE);
    
        [self performSegueWithIdentifier:UMSegueRoute sender:self];
    }];
    
    StopArrivalCellModel *arrivalCellModel = self.model.arrivalsServicingStopCellModels[self.activeIndexPath.row];
    
    if (![arrivalCellModel.firstArrivalString isEqualToString:@"Arriving Now"] &&
        ![arrivalCellModel.firstArrivalString isEqualToString:@"01"] &&
        ![arrivalCellModel.firstArrivalString isEqualToString:@"--"]) {
        [actionSheet addButtonWithTitle:@"Notify before arrival" handler:^ {
            SendEvent(ANALYTICS_STOP_ARRIVAL_NOTIFY);
            
            [self performSegueWithIdentifier:UMSegueNotify sender:self];
        }];
    }
    
    [actionSheet addCancelButtonWithTitle:@"Dismiss" handler:^ {
        SendEvent(ANALYTICS_STOP_ARRIVAL_DISMISS);
    }];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionRoutes:
            return 130.0f;
        case SectionAddress:
            return ADDRESS_CELL_HEIGHT;
        case SectionMisc:
            return 50.0f;
        default:
            return 44.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSStringForSection(section);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == SectionRoutes) {
        return [NSString stringWithFormat:FORMATTED_LAST_UPDATED, [self.model timeSinceRoutesRefresh]];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionRoutes) {
        if (self.model.arrivalsServicingStop.count == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneCell" forIndexPath:indexPath];
            
            cell.textLabel.text = NONE;
            cell.textLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightLight size:17.0f];
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
        self.addressCell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
        if (self.addressCell == nil) {
            self.addressCell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressCell"];
        }
        self.addressCell.model = cellModel;
        
        return self.addressCell;
    } else if (indexPath.section == SectionMisc) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
        cell.textLabel.text = self.model.miscCells[indexPath.row];
        cell.textLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightLight size:17.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
  
    return nil;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.activeIndexPath = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (indexPath.section == SectionRoutes && self.model.arrivalIDsServicingStop.count != 0) {
        [self presentRouteActionChooserForArrival:self.model.arrivalsServicingStop[self.activeIndexPath.row]];
    }
    
    else if (indexPath.section == SectionAddress) {
        SendEvent(ANALYTICS_STOP_ADDRESS);
        
        [self performSegueWithIdentifier:UMSegueMap sender:self];
    }
    
    else if (indexPath.section == SectionMisc) {
        
        if (indexPath.row == MiscCellDirections) {
            SendEvent(ANALYTICS_STOP_DIRECTIONS);

            NSString *address = [NSString stringWithFormat:FORMATTED_APPLE_MAPS_DIRECTIONS, self.model.stop.coordinate.latitude, self.model.stop.coordinate.longitude];
            NSURL *url = [[NSURL alloc] initWithString:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL:url];
            
            self.shouldPurgeMap = NO;
        }
        
        else if (indexPath.row == MiscCellStreetView) {
            SendEvent(ANALYTICS_STOP_STREET_VIEW);

            self.shouldPurgeMap = NO;

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                StreetViewController *controller = [[StreetViewController alloc] initWithCoordinate:self.model.stop.coordinate
                                                                                            heading:[self.model.stop.heading integerValue]
                                                                                              title:self.model.stop.humanName];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:navController animated:YES completion:^ {
                        self.shouldPurgeMap = YES;
                    }];
                });
            });
        }
    }
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.shouldPurgeMap = NO;

    if ([segue.identifier isEqual:UMSegueRoute]) {
        Arrival *arrival = self.model.arrivalsServicingStop[self.activeIndexPath.row];
        RouteViewController *routeController = (RouteViewController *)segue.destinationViewController;
        routeController.arrival = arrival;
    } else if ([segue.identifier isEqual:UMSegueMap]) {
        MapViewController *viewController = (MapViewController *)segue.destinationViewController;
        viewController.startingStop = self.model.stop;
        viewController.arrivalIDsServicingStop = self.model.arrivalIDsServicingStop;
    } else if ([segue.identifier isEqual:UMSegueNotify]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        NotifyViewController *viewController = (NotifyViewController *)navController.viewControllers[0];
        viewController.stop = self.model.stop;
        viewController.arrival = self.model.arrivalsServicingStop[self.activeIndexPath.row];
    }
}

@end
