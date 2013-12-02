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

@interface StreetViewController ()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSObject<MKAnnotation> *annotation;

@end

@implementation StreetViewController

- (instancetype)initWithAnnotation:(NSObject<MKAnnotation> *)annotation {
    if (self = [super init]) {
        _coordinate = annotation.coordinate;
        _annotation = annotation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSPanoramaView *panoView = [GMSPanoramaView panoramaWithFrame:CGRectZero nearCoordinate:_coordinate];
    
    CLLocationDirection heading = 0;
    if ([_annotation class] == [StopAnnotation class]) {
        StopAnnotation *stopAnnotation = (StopAnnotation *)_annotation;
        heading = [stopAnnotation.stop.heading doubleValue];
    } else if ([_annotation class] == [BusAnnotation class]) {
        BusAnnotation *busAnnotation = (BusAnnotation *)_annotation;
        heading = [busAnnotation.bus.heading doubleValue];
    }
    
    panoView.camera = [GMSPanoramaCamera cameraWithHeading:heading pitch:-10 zoom:1];
    self.view = panoView;
    
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = closeBarButton;
    
    self.title = _annotation.title;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
