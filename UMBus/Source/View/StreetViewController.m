//
//  StreetViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "StreetViewController.h"
#import "StopAnnotation.h"
#import "BusAnnotation.h"
#import "Bus.h"
#import "Stop.h"
#import "Constants.h"

@interface StreetViewController ()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSUInteger heading;

@end

@implementation StreetViewController

- (instancetype)initWithAnnotation:(NSObject<MKAnnotation> *)annotation {
    if (self = [super init]) {
        _coordinate = annotation.coordinate;
        self.title = annotation.title;
    }
    return self;
}

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        _coordinate = stop.coordinate;
        _heading = (NSUInteger)stop.heading;
        self.title = stop.humanName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSPanoramaView *panoView = [GMSPanoramaView panoramaWithFrame:CGRectZero nearCoordinate:_coordinate];
    if (_heading) panoView.camera = [GMSPanoramaCamera cameraWithHeading:_heading pitch:-10 zoom:1];
    self.view = panoView;
    
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:kDismiss style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = closeBarButton;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
