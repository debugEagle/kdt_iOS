//
//  CYLTabBarController.m
//  CYLCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "BTTabBarController.h"
#import "BTTabBar.h"
#import <objc/runtime.h>
NSUInteger CYLTabbarItemsCount = 0;

@interface UIViewController (CYLTabBarControllerItemInternal)

- (void)cyl_setTabBarController:(BTTabBarController *)tabBarController;

@end

@interface BTTabBarController () <UITabBarDelegate,UITabBarControllerDelegate>

@end
@implementation BTTabBarController
@synthesize viewControllers = _viewControllers;

#pragma mark -
#pragma mark - Life Cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    // 处理tabBar，使用自定义 tabBar 添加 发布按钮
    [self setUpTabBar];
    self.delegate = self;
}

#pragma mark -
#pragma mark - Private Methods

/**
 *  利用 KVC 把 系统的 tabBar 类型改为自定义类型。
 */
- (void)setUpTabBar {
    [self setValue:[[BTTabBar alloc] init] forKey:@"tabBar"];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        if (_tabBarItemsAttributes) {
            if (_tabBarItemsAttributes.count != _viewControllers.count) {
                [NSException raise:@"BTTabBarController" format:@"The count of CYLTabBarControllers is not equal to the count of tabBarItemsAttributes.【中文】设置_tabBarItemsAttributes属性时，请确保元素个数与控制器的个数相同，并在方法`-setViewControllers:`之前设置"];
            }
        }
        CYLTabbarItemsCount = [viewControllers count];
        NSUInteger idx = 0;
        for (UIViewController *viewController in viewControllers) {
            [self addOneChildViewController:viewController
                                  WithTitle:_tabBarItemsAttributes[idx][CYLTabBarItemTitle]
                            normalImageName:_tabBarItemsAttributes[idx][CYLTabBarItemImage]
                          selectedImageName:_tabBarItemsAttributes[idx][CYLTabBarItemSelectedImage]
                                        tag:idx];
            [viewController cyl_setTabBarController:self];
            idx++;
        }
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController cyl_setTabBarController:nil];
        }
        _viewControllers = nil;
    }
}

/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param normalImageName   图片
 *  @param selectedImageName 选中图片
 */
- (void)addOneChildViewController:(UIViewController *)viewController
                        WithTitle:(NSString *)title
                  normalImageName:(NSString *)normalImageName
                selectedImageName:(NSString *)selectedImageName
                              tag:(NSInteger)tag
{
    
    viewController.tabBarItem.title         = title;
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image         = normalImage;
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
    viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
    viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    viewController.tabBarItem.tag = tag;
    
    [self addChildViewController:viewController];
}

//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    BTNavigationController *nav = (BTNavigationController *)viewController;
//    if ([[nav.viewControllers firstObject] isKindOfClass:[BTMessageVC class]]) {
//        BTLoginVC *loginVC = [[BTLoginVC alloc] init];
//        [self presentViewController:loginVC animated:YES completion:nil];
//        return NO;
//    }
//    
//    return YES;
//}

@end

#pragma mark - UIViewController+CYLTabBarControllerItem

@implementation UIViewController (CYLTabBarControllerItemInternal)

- (void)cyl_setTabBarController:(BTTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(cyl_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (CYLTabBarController)

- (BTTabBarController *)cyl_tabBarController {
    BTTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(cyl_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController cyl_tabBarController];
    }
    
    return tabBarController;
}

@end