//
//  NotifyViewController.m
//  MBus
//
//  Created by Jonah Grant on 3/30/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "NotifyViewController.h"
#import "NotificationManager.h"
#import "Arrival.h"
#import "Stop.h"
#import "ArrivalStop.h"
#import "DataStore.h"
#import "UMAdditions+UIFont.h"

@interface NotifyViewController ()

@property (nonatomic) NSTimeInterval seconds;

@end

@implementation NotifyViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    self.title = @"Notify me...";
    
    self.seconds = [self firstBusArrival];
    
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = closeBarButton;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark -

- (void)dismiss {
	[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (NSTimeInterval)firstBusArrival {
    NSTimeInterval toa = 0;
    BOOL hasBus1 = [[DataStore sharedManager] arrivalHasBus1WithArrivalID:self.arrival.id];
    BOOL hasBus2 = [[DataStore sharedManager] arrivalHasBus2WithArrivalID:self.arrival.id];
    ArrivalStop *stop = [[DataStore sharedManager] arrivalStopForRouteID:self.arrival.id stopName:self.stop.uniqueName];
    
    if (hasBus1 && hasBus2) {
        if (stop.timeOfArrival >= stop.timeOfArrival2) {
            toa = stop.timeOfArrival2;
        } else {
            toa = stop.timeOfArrival;
        }
    } else if (hasBus1 && !hasBus2) {
        toa = stop.timeOfArrival;
    } else if (!hasBus1 && hasBus2) {
        toa = stop.timeOfArrival2;
    } else {
        toa = -1;
    }
    
    return toa;
}

- (NSString *)timeOfArrivalForTimeInterval:(NSTimeInterval)interval {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate *date = [NSDate dateWithTimeInterval:self.seconds sinceDate:[NSDate date]];
    NSDate *eta = [NSDate dateWithTimeInterval:-interval sinceDate:date];
    return [dateFormatter stringFromDate:eta];
}

#pragma mark - UITableViewDelegate delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int minutes = ((NSInteger)self.seconds / 60) % 60;
    return (minutes > 5) ? (self.seconds / 60) : (self.seconds / 30);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
    int minutes = ((NSInteger)self.seconds / 60) % 60;
    int minutesTextInt = (minutes > 5) ? indexPath.row + 1 : (30.0 * (indexPath.row + 1));
    NSString *minutesText = [NSString stringWithFormat:@"%i", minutesTextInt];
    NSString *minutesLabel = (minutes > 5) ? ([minutesText isEqualToString:@"1"]) ? @"minute" : @"minutes" :  ([minutesText isEqualToString:@"1"]) ? @"second" : @"seconds";
    
    BOOL showedInMinutes = (minutes > 5);
    int seconds;
    if (showedInMinutes) {
        seconds = (indexPath.row + 1) * 60;
    } else {
        seconds = (indexPath.row + 1) * 30;
    }
    
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ before arrival", minutesText, minutesLabel];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)", [self timeOfArrivalForTimeInterval:seconds]];
	cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int minutes = ((NSInteger)self.seconds / 60) % 60;
    BOOL showedInMinutes = (minutes > 5);
    int seconds;
    if (showedInMinutes) {
        seconds = (indexPath.row + 1) * 60;
    } else {
        seconds = (indexPath.row + 1) * 30;
    }
    
    int minutesTextInt = (minutes > 5) ? indexPath.row + 1 : (30.0 * (indexPath.row + 1));
    NSString *minutesText = [NSString stringWithFormat:@"%i", minutesTextInt];
    NSString *minutesLabel = (minutes > 5) ? ([minutesText isEqualToString:@"1"]) ? @"minute" : @"minutes" :  ([minutesText isEqualToString:@"1"]) ? @"second" : @"seconds";

    NSString *message = [NSString stringWithFormat:@"The %@ bus is arriving at %@ in about %@ %@.", self.arrival.name, self.stop.humanName, minutesText, minutesLabel];
    NotificationManager *notificationManager = [[NotificationManager alloc] init];
    [notificationManager scheduleNotificationWithFireDate:[NSDate dateWithTimeInterval:self.seconds - seconds
                                                                             sinceDate:[DataStore sharedManager].arrivalsTimestamp]
                                                  message:message];
    
    NSString *analyticsLabel = [NSString stringWithFormat:@"%@ %@", minutesText, minutesLabel];
    SendEventWithLabel(@"schedule_notification", analyticsLabel);
    
    [self dismiss];
}

@end
