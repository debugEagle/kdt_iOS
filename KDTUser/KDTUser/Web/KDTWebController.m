//
//  BTWebViewVC.m
//  BanTang
//
//  Created by 沈文涛 on 15/11/29.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "KDTWebController.h"
#import "UIImage+RXExtension.h"
#import "UIBarButtonItem+RXExtension.h"
#import "conf.h"

@interface KDTWebController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation KDTWebController

+(instancetype) sharedInstance {
    static id _webController;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _webController = [[self alloc] init];
    });
    return _webController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //	[self.navigationController.navigationBar setBackgroundImage:[UIImage rx_captureImageWithImageName:@"nav_backgroud"]
    //												  forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView loadHTMLString:@"" baseURL:nil];
}

- (void)setIsModalStyle:(BOOL)isModalStyle
{
    _isModalStyle = isModalStyle;
    
    if (self.isModalStyle) {
        UIBarButtonItem *cancelItem = [UIBarButtonItem rx_barBtnItemWithNmlImg:@"Login_close_btn"
                                                                        hltImg:@"Login_close_btn"
                                                                        target:self
                                                                        action:@selector(backButtonDidClick)];
        self.navigationItem.rightBarButtonItem = cancelItem;
        
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        UIBarButtonItem *shareItem = [UIBarButtonItem rx_barBtnItemWithNmlImg:@"share_item_icon"
                                                                       hltImg:@"share_item_icon"
                                                                       target:self
                                                                       action:@selector(shareItemDidClick)];
        self.navigationItem.rightBarButtonItem = shareItem;
    }
}

- (void)shareItemDidClick
{
    
}

- (void)backButtonDidClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
        _webView.frame = CGRectMake(0, 64, kScreen_Width, kScreen_Height);
    }
    return _webView;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView stopLoading];
    [self.webView loadRequest:request];
}
@end
