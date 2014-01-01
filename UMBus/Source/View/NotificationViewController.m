//
//  NotificationViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/28/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationViewControllerModel.h"

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [[NotificationViewControllerModel alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
