//
//  BTTabBarControllerConfig.m
//  BanTang
//
//  Created by Ryan on 15/11/27.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "conf.h"
#import "KDTTabBarConfig.h"
#import "KDTNavigationController.h"
#import "KDTHomeViewController.h"
#import "ScpController.h"
#import "SettingsController.h"

@interface KDTTabBarConfig ()

@property (nonatomic, readwrite, strong) BTTabBarController *tabBarController;

@end

@implementation KDTTabBarConfig


- (BTTabBarController *)tabBarController
{
    if (!_tabBarController) {
        KDTHomeViewController *home = [[KDTHomeViewController alloc] init];
        home.title = @"游戏播报";
        KDTNavigationController *firstNavigationController = [[KDTNavigationController alloc]
                                                             initWithRootViewController:home];
        
        
        UIViewController* tools = [[UIViewController alloc] init];
        tools.title = @"百宝箱";
        KDTNavigationController *secondNavigationController = [[KDTNavigationController alloc]
                                                               initWithRootViewController:tools];
        
        ScpController *script = [[ScpController alloc] initWithStyle:UITableViewStyleGrouped];
        script.title = @"我的秘籍";
        KDTNavigationController *thirdNavigationController = [[KDTNavigationController alloc]
                                                              initWithRootViewController:script];
        
        SettingsController *settings = [[SettingsController alloc] init];
        settings.title = @"设置";
        KDTNavigationController *fourthNavigationController = [[KDTNavigationController alloc]
                                                              initWithRootViewController:settings];
        
        BTTabBarController *tabBarController = [[BTTabBarController alloc] init];
        
        [self customizeTabBarForController:tabBarController];
        
        [tabBarController setViewControllers:@[firstNavigationController,
                                               secondNavigationController,
                                               thirdNavigationController,
                                               fourthNavigationController]];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

/*
 *
 在`-setViewControllers:`之前设置TabBar的属性，
 *
 */
- (void)customizeTabBarForController:(BTTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"头条",
                            CYLTabBarItemImage : @"tab_首页",
                            CYLTabBarItemSelectedImage : @"tab_首页_pressed",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"百宝箱",
                            CYLTabBarItemImage : @"tab_百宝箱",
                            CYLTabBarItemSelectedImage : @"tab_百宝箱_pressed",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"秘籍",
                            CYLTabBarItemImage : @"tab_秘籍",
                            CYLTabBarItemSelectedImage : @"tab_秘籍_pressed",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"设置",
                            CYLTabBarItemImage : @"tab_设置",
                            CYLTabBarItemSelectedImage : @"tab_设置_pressed"
                            };
    NSArray *tabBarItemsAttributes = @[ dict1, dict2, dict3, dict4 ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
    [self setUpTabBarItemTextAttributes];
}

/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes {
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    //UITabBar *tabBarAppearance = [UITabBar appearance];
    //[tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tab_bar_bg"]];
}
@end
