//
//  EPChildAppVC.m
//  EPIMApp
//
//  Created by Ryan on 15/10/27.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "EPChildAppVC.h"
#import "EPJsBridge.h"

#import <AVFoundation/AVFoundation.h>

@interface EPChildAppVC () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) EPJsBridge *bridge;

@end

@implementation EPChildAppVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置oc和js的桥接
    _bridge = [EPJsBridge bridgeForWebView:self.webView webViewDelegate:self];
    
    [self.view addSubview:self.webView];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.delegate = self;
        _webView.frame = self.view.bounds;
    }
    return _webView;
}
@end
