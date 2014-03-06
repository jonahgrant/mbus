//
//  MiscViewController.m
//  MBus
//
//  Created by Jonah Grant on 2/27/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "MiscViewController.h"
#import "MiscViewControllerModel.h"
#import "VTAcknowledgementsViewController.h"
#import "Constants.h"
#import "UMAdditions+UIFont.h"
#import "CGLMailHelper.h"
#import "WebViewController.h"
#import "UMSegueIdentifiers.h"

@interface MiscViewController ()

@property (nonatomic, strong, readwrite) MiscViewControllerModel *model;

@end

@implementation MiscViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[MiscViewControllerModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetInterface];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.model.cells objectForKey:self.model.sections[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.model.sections[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == self.model.sections.count - 1) {
        return DISCLAIMER;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self.model.cells objectForKey:self.model.sections[indexPath.section]] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightLight size:18.0f];
    
    return cell;
}

#pragma mark - Table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionMore) {
        if (indexPath.row == NSIntegerForCell(CellMap)) {
            [self performSegueWithIdentifier:UMSegueMap sender:self];
        } else if (indexPath.row == NSIntegerForCell(CellAnnouncements)) {
            [self performSegueWithIdentifier:UMSegueAnnouncements sender:self];
        }
    } else if (indexPath.section == NSIntegerForSection(SectionLegal)) {
        if (indexPath.row == NSIntegerForCell(CellAcknowledgements)) {
            NSString *path = [[NSBundle mainBundle] pathForResource:ACKNOWLEDGEMENTS_PLIST_PATH ofType:ACKNOWLEDGEMENTS_PLIST_TYPE];
            VTAcknowledgementsViewController *viewController = [[VTAcknowledgementsViewController alloc] initWithAcknowledgementsPlistPath:path];
            viewController.licenseTextViewFont = [UIFont helveticaNeueWithWeight:TypeWeightLight size:17.0f];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if (indexPath.section == NSIntegerForSection(SectionContact)) {
        if (indexPath.row == NSIntegerForCell(CellSupport)) {
            UIViewController *viewController = [CGLMailHelper supportMailViewControllerWithRecipient:SUPPORT_EMAIL_ADDRESS
                                                                                     subject:SUPPORT_EMAIL_SUBJECT
                                                                                  completion:nil];
            [self presentViewController:viewController animated:YES completion:NULL];
        } else if (indexPath.row == NSIntegerForCell(CellContact)) {
            UIViewController *viewController = [CGLMailHelper mailViewControllerWithRecipients:@[DEVELOPER_EMAIL_ADDRESS]
                                                                                       subject:DEVELOPER_EMAIL_SUBJECT
                                                                                       message:nil
                                                                                        isHTML:NO
                                                                                includeAppInfo:NO
                                                                                    completion:NULL];
            [self presentViewController:viewController animated:YES completion:NULL];
        }
    } else if (indexPath.section == NSIntegerForSection(SectionMisc)) {
        if (indexPath.row == NSIntegerForCell(CellReview)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RATE_APP_URL]];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        } else if (indexPath.row == NSIntegerForCell(CellAbout)) {
            WebViewController *viewController = [[WebViewController alloc] initWithURL:[NSURL URLWithString:@"http://mbus.pts.umich.edu/about-us/"]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end