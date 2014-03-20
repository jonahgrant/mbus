//
//  WebViewController.m
//  MBus
//
//  Created by Jonah Grant on 3/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

@property (nonatomic, strong, readwrite) NSURL *url;
@property (nonatomic, strong, readwrite) UIWebView *webView;

@end

@implementation WebViewController

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetInterface];
}

#pragma mark - UIWebView

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
