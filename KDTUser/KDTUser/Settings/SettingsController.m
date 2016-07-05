//
//  MenuCtr.m
//  AR
//
//  Created by wd on 15-5-16.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import "SettingsController.h"
#import "conf.h"
#import "SettingsHeaderView.h"
#import "HPLocalClient.h"
#import "KDTTxtController.h"
#import "KDTWebController.h"
#import "kdt_declaration.h"


@interface SettingsController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableview;
@property (nonatomic, strong) SettingsHeaderView* headerView;
@property (nonatomic, strong) UISwitch* switched;

@end

@implementation SettingsController

-(instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableview];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    HPLocalClient* hp = [HPLocalClient sharedInstance];
    [center addObserver:self selector:@selector(updateStatus:) name:@"statusChange" object:hp];
    [center addObserver:self selector:@selector(updateLicence:) name:@"licenceChange" object:hp];
    
    /* 第一次启动时候手动触发 */
    [hp onStatus:[hp getEnv:@"status"]];
    [hp onLicence:[hp getEnv:@"licence"]];
}


-(void) updateLicence:(NSNotification*) notify {
    NSDictionary* licence = notify.userInfo;
    WDLog(@"%@", licence);
    [self.headerView updateLicence:licence];
}


-(void) updateStatus:(NSNotification*) notify {
    NSDictionary* status = notify.userInfo;
    WDLog(@"%@", status);
    BOOL isOn = status[kStutsListening] ? YES : NO;
    [self.switched setOn:isOn animated:NO];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
    /* 去除1像素黑线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self adjustScroll];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger ret = 0;
    switch (section) {
        case 0:
            ret = 1;
            break;
        case 1:
            ret = 2;
            break;
        case 2:
            ret = 3;
            break;
        default:
            break;
    }
    return ret;
}

- (SettingsHeaderView*) headerView {
    if (!_headerView) {
        float hight = kScreen_Width * (500.f / 750.f);
        _headerView = [[SettingsHeaderView alloc] initWithFrame:(CGRect){0, 0, kScreen_Width, hight}];
    }
    return _headerView;
}

- (UITableView*) tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:(CGRect){0, 0, kScreen_Width, kScreen_Height} style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource= self;
        //_tableview.scrollEnabled = NO;
        _tableview.tableHeaderView = self.headerView;
        //_tableview.backgroundColor =
        _tableview.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        //UIView* back = [[UIView alloc] init];
        //back.backgroundColor = kUIColorFromRGB(0xf0f0f0);
        //[_tableview setBackgroundView:back];
        [_tableview insertSubview:self.headerView atIndex:0];
        
    }
    return _tableview;
}


-(void)switchAction:(id)sender
{
    HPLocalClient* hp = [HPLocalClient sharedInstance];
    if ([self.switched isOn])
        [(id)hp.proxy startListen];
    else
        [(id)hp.proxy stopListen];
}

-(UISwitch*) switched {
    if (!_switched) {
        _switched = [[UISwitch alloc] init];
        [_switched addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switched;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [self.tableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        UIFont *newFont = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.font = newFont;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.font = newFont;
                        cell.textLabel.text = @"启动服务";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        cell.accessoryView = self.switched;
                        cell.imageView.image = [UIImage imageNamed:@"Settings-start"];
                        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                        break;
                }
                break;
                
            case 1:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"检查更新";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.imageView.image = [UIImage imageNamed:@"Settings-update"];
                        break;
                    case 1:
                        cell.textLabel.text = @"购买服务";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.imageView.image = [UIImage imageNamed:@"Settings-buy"];;
                        break;
                }
                break;
                
            case 2:
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"函数手册";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.imageView.image = [UIImage imageNamed:@"Settings-manual"];
                        break;
                    case 1:
                        cell.textLabel.text = @"免责声明";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.imageView.image = [UIImage imageNamed:@"Settings-licence"];
                        break;
                    case 2:
                        cell.textLabel.text = @"更多产品";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.imageView.image = [UIImage imageNamed:@"Settings-more"];
                        break;
                }
                break;
        }
    }
    return cell;
}

-(void) showWeb:(NSString*) url withTitle:(NSString*) title {
    KDTWebController* web = [KDTWebController sharedInstance];
    web.title = title;
    web.url =  url;
    web.isModalStyle = YES;
    [self.navigationController pushViewController:web animated:YES];
}

-(void) showText:(NSString*) text withTitle:(NSString*) title {
    KDTTxtController* txt = [KDTTxtController sharedInstance];
    txt.title = title;
    txt.text = text;
    [self.navigationController pushViewController:txt animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* header = [[UIView alloc]init];
    header.backgroundColor = kUIColorFromRGB(0xf0f0f0);;
    return [header autorelease];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* footer = [[UIView alloc]init];
    footer.backgroundColor = kUIColorFromRGB(0xf0f0f0);;
    return [footer autorelease];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        /* 启动服务 */
        case 0:
            break;
        case 1:
            switch (indexPath.row) {
                /* 检查更新 */
                case 0:
                    break;
                /* 购买服务 */
                case 1:
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row) {
                /* 函数手册 */
                case 0:
                    [self showWeb:@"https://www.zybuluo.com/koudaitool/note/404547" withTitle:@"函数手册"];
                    break;
                /* 免责声明 */
                case 1:
                    [self showText:KDT_DECLARATION withTitle:@"免责声明"];
                    break;
                /* 更多产品 */
                case 2:
                    [self showWeb:@"http://www.koudaitool.com/" withTitle:@"更多产品"];
                    break;
            }
            break;
    }
}

-(void) adjustScroll {
    CGFloat y = self.tableview.contentOffset.y;
    if (y <= 0) {
        UIView* view = self.headerView.background;
        view.transform = CGAffineTransformIdentity;
        view.transform = CGAffineTransformScale(view.transform, 1 - y*0.01, 1 - y*0.01);
    }
    float hight = kScreen_Width * (500.f / 750.f) - 64;
    if (y >= hight && self.navigationController.navigationBarHidden) {
        NSLog(@"show");
        self.navigationController.navigationBarHidden = NO;
    }
    
    if (y <= hight && !self.navigationController.navigationBarHidden) {
        NSLog(@"hiden");
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIPanGestureRecognizer *)pan {
    [self adjustScroll];
}




@end
