//
//  KDTHomeViewController.m
//  KDTUser
//
//  Created by wd on 16/5/2.
//  Copyright © 2016年 wd. All rights reserved.
//

#import "KDTHomeViewController.h"
#import "KDtHomeHeaderView.h"
#import "UIView+Frame.h"
#import "UIBarButtonItem+RXExtension.h"
#import "UINavigationBar+Awesome.h"
#import "conf.h"
#import "KDTWebController.h"
#import "KDTTxtController.h"
#import "KDTNavigationController.h"
#import "KDTNewCell.h"
#import "UITableViewCell+Ident.h"
#import "PullToRefreshCoreTextView.h"
#import "NSDate+DistanceNow.h"
#import "BTLoadingView.h"
#import "NetStub.h"
#import "BTPageLoadFooterView.h"

@interface KDTHomeViewController ()

@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) PullToRefreshCoreTextView* pullToRefreshView;
@property (nonatomic, strong) UIView* titleView;
@property (nonatomic, strong) KDtHomeHeaderView* headerView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) BTPageLoadFooterView* footerView;
@property (nonatomic, strong) NSMutableArray* bannerData;
@property (nonatomic, strong) NSMutableArray* tableData;

@property (nonatomic, strong) NSDate* pullTime;
@end

@implementation KDTHomeViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = BTBackgroundColor;
        self.tableData = [[NSMutableArray alloc] init];
        self.bannerData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.loadingView];
    [self loadDataFromStart:YES];
    [self getBanner];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
    //                                                  forBarMetrics:UIBarMetricsDefault];
    //    /* 去除1像素黑线 */
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BTPageLoadFooterView *) footerView {
    if (!_footerView) {
        __weak typeof(self) that = self;
        _footerView = [[BTPageLoadFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
        [_footerView setRefreshBlock:^{
            [that loadDataFromStart:NO];
        }];
    }
    return _footerView;
}

- (UITableView*) tableView {
    if ((!_tableView)) {
        _tableView = [[UITableView alloc] initWithFrame:(CGRect){0, 75, kScreen_Width - 20, kScreen_Height}
                                                  style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        _tableView.backgroundColor = BTBackgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        [_tableView addSubview:self.pullToRefreshView];
        [self.pullToRefreshView setScrollView:_tableView];
        [_tableView setCenter:CGPointMake(self.view.center.x, _tableView.center.y)];
    }
    return _tableView;
}



- (void)loadDataFromStart:(BOOL)boolean
{
    self.pullTime = [NSDate date];
    NSDictionary* obj = boolean ? [self.tableData firstObject] : [self.tableData lastObject];
    NSString* op = boolean ? @"gt": @"lt";
    
    int queryId = (int)[[obj objectForKey:@"uid"] integerValue];
    NSString* url = [NSString stringWithFormat:@"http://133.130.109.41:3000/api/paper/%d?op=%@&limit=5", queryId, op];
    NSLog(@"load: %d",queryId);
    __weak typeof(self) that = self;
    
    /* test get banner */
    [self getBanner];
    
    [NetStub Get:[NSURL URLWithString:url]
         timeOut:5
       onSuccess:^(NSError* error, id data){
           _pullToRefreshView.pullText = @"Successful";
           if ([data count]) {
               [that.tableData addObjectsFromArray:data];
               
               /* uid大的是新文章在数组前面 */
               NSArray *sort = [that.tableData sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
                   return 0 - [[obj1 objectForKey:@"uid"] compare:[obj2 objectForKey:@"uid"]];
               }];
               
               that.tableData = [NSMutableArray arrayWithArray:sort];
               [that.tableView reloadData];
           }
           [that hideLoading];
       }
       onFailure:^(NSError* error){
           NSLog(@"%@", error);
           _pullToRefreshView.pullText = @"Failure";
           [that hideLoading];
       }];
}


- (void)hideLoading
{
    [self.loadingView hideAnimation];
    [self.pullToRefreshView performSelector:@selector(endLoading) withObject:nil afterDelay:1];
    [self.footerView endRefreshing];
}


- (PullToRefreshCoreTextView*) pullToRefreshView {
    if (!_pullToRefreshView) {
        __weak typeof(self) that = self;
        NSString* pullText = [NSDate distanceNow:self.pullTime];
        _pullToRefreshView = [[PullToRefreshCoreTextView alloc] initWithFrame:(CGRect){-10, -20, kScreen_Width, 20}
                                                                     pullText:pullText
                                                                pullTextColor:[UIColor blackColor]
                                                                 pullTextFont:[UIFont systemFontOfSize:14]
                                                               refreshingText:@"success!"
                                                          refreshingTextColor:[UIColor blackColor]
                                                           refreshingTextFont:[UIFont systemFontOfSize:16]
                                                                 beforeAction:^{
                                                                     NSLog(@"!before pull");
                                                                     _pullToRefreshView.pullText = [NSDate distanceNow:self.pullTime];
                                                                 }
                                                                  startAction:^{
                                                                      NSLog(@"!start pull");
                                                                      [that loadDataFromStart:YES];
                                                                  }
                                                                  afterAction:^{}];
    }
    return _pullToRefreshView;
}


- (KDtHomeHeaderView*) headerView {
    if (!_headerView) {
        CGRect rect = {0.f, 0.f, kScreen_Width - 20, 150};
        _headerView = [[KDtHomeHeaderView alloc] initWithFrame:rect];
        [_headerView setCenter:CGPointMake(self.view.center.x, _headerView.center.y)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (void) getBanner {
    if (![self.bannerData count]) {
        NSString* url = [NSString stringWithFormat:@"http://133.130.109.41:3000/api/banner"];
        __weak typeof(self) that = self;
        [NetStub Get:[NSURL URLWithString:url]
             timeOut:5
           onSuccess:^(NSError* error, id data){
               NSLog(@"data:%@", data);
               
               if ([data isKindOfClass:[NSArray class]] && [data count]) {
                   that.bannerData = data;
                   NSMutableArray* images = [NSMutableArray array];
                   for (NSDictionary* banner in data) {
                       NSString* imageUrl = [banner objectForKey:@"image"];
                       if (!imageUrl)
                           imageUrl = @"banner-default";
                       [images addObject:[NSURL URLWithString:imageUrl]];
                   }
                   [_headerView setImages:images];
               }
           }
           onFailure:^(NSError* error){
               NSLog(@"%@", error);
           }];
    }
}


- (void)headerView:(KDtHomeHeaderView *)headerView didClickBannerViewWithIndex:(NSInteger)index {
    NSLog(@"index:%zi", index);
    
    if (self.bannerData.count > index) {
        NSDictionary* banner = [self.bannerData objectAtIndex:index];
        KDTWebController* web = [KDTWebController sharedInstance];
        web.title = @"活动详情";
        web.url = [banner objectForKey:@"url"];
        web.isModalStyle = YES;
        [self.navigationController pushViewController:web animated:YES];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* doc = [_tableData objectAtIndex:indexPath.row];
    Class cellClass = NSClassFromString([doc objectForKey:@"type"]);
    return [cellClass heightWithContent:doc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* doc = [_tableData objectAtIndex:indexPath.row];
    Class cellClass = NSClassFromString([doc objectForKey:@"type"]);
    KDTNewCell *cell = [tableView dequeueReusableCellWithIdentifier:[cellClass ident]];
    if (cell == nil) {
        NSLog(@"%@", cellClass);
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[cellClass ident]];
    }
    [cell renderWithContent:doc];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* doc = [_tableData objectAtIndex:indexPath.row];
    KDTWebController* web = [KDTWebController sharedInstance];
    web.title = [doc objectForKey:@"game"];
    web.url =  [doc objectForKey:@"url"];
    web.isModalStyle = YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.tableData.count - 1) {
        NSLog(@"willDisplayCell:%ld", (long)indexPath.row);
        [self.footerView startRefreshing];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    [self.footerView startRefreshing];
}

- (BTLoadingView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [BTLoadingView loadingViewToView:self.view];
        [_loadingView startAnimation];
    }
    return _loadingView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
