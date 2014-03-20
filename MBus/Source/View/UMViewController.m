//
//  UMViewController.h
//  MBus
//
//  Created by Jonah Grant on 3/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "UMViewController.h"
#import "Constants.h"

@implementation UIViewController (Private)

// shared functions

- (void)setViewControllerTitle {
    self.title = NSStringForUIViewController(self);
}

- (void)_resetInterface {
    BOOL didAnimate = [[self transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // the order of these two lines of code matters.
        // if they were to change, the animation would not be as fluid as intended
        // DO NOT CHANGE IT.
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.barTintColor = nil;
        
        self.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.141176 green:0.529412 blue:0.980392 alpha:1.0000];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>context) {
        self.navigationController.navigationBar.translucent = YES;
    }];
    
    if (!didAnimate) {
        self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.141176 green:0.529412 blue:0.980392 alpha:1.0000];
    }
}

- (void)_setInterfaceWithColor:(UIColor *)color {
    BOOL didAnimate = [[self transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.tabBarController.tabBar.tintColor = color;
        self.navigationController.navigationBar.translucent = NO;
        
        // the order of these two lines of code matters.
        // if they were to change, the animation would not be as fluid as intended
        // DO NOT CHANGE IT.
        self.navigationController.navigationBar.barTintColor = color;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    } completion:nil];

    // if the view has already been loaded and is simply being revisted from another tab, the tintColor property
    // must be set again as the transitionCoordinater does not execute again.
    
    if (!didAnimate) {
        self.tabBarController.tabBar.tintColor = color;
    }
}

@end

@implementation UMTableViewController

- (void)viewDidLoad {
    [self setViewControllerTitle];
}

- (void)viewDidAppear:(BOOL)animated {
    SendPage(NSStringFromClass([self class]));
}

- (void)resetInterface {
    [self _resetInterface];
}

- (void)setInterfaceWithColor:(UIColor *)color {
    [self _setInterfaceWithColor:color];
}

@end

@implementation UMViewController

- (void)viewDidLoad {
    [self setViewControllerTitle];
}

- (void)viewDidAppear:(BOOL)animated {
    SendPage(NSStringFromClass([self class]));
}

- (void)resetInterface {
    [self _resetInterface];
}

- (void)setInterfaceWithColor:(UIColor *)color {
    [self _setInterfaceWithColor:color];
}

@end
