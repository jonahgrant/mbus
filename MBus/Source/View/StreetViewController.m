//
//  StreetViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "StreetViewController.h"
#import "Constants.h"

@interface StreetViewController ()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSUInteger heading;
@property (nonatomic, copy) NSString *locationTitle;

@end

@implementation StreetViewController

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate heading:(NSUInteger)heading title:(NSString *)title {
    if (self = [super init]) {
        _coordinate = coordinate;
        _heading = heading;
        _locationTitle = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _locationTitle;
    
    self.view = ({
        GMSPanoramaView *panoView = [GMSPanoramaView panoramaWithFrame:CGRectZero nearCoordinate:_coordinate];
        if (_heading > 0) {
            panoView.camera = [GMSPanoramaCamera cameraWithHeading:_heading pitch:-10 zoom:1];
        }
        panoView;
    });
    
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:DISMISS style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = closeBarButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetInterface];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
