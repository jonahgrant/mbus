//
//  StreetViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "StreetViewController.h"

@interface StreetViewController ()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation StreetViewController

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self = [super init]) {
        _coordinate = coordinate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSPanoramaView *panoView = [GMSPanoramaView panoramaWithFrame:CGRectZero nearCoordinate:_coordinate];
    panoView.navigationGestures = NO;
    self.view = panoView;
    
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = closeBarButton;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
