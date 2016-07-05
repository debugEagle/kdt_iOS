//
//  BWDNavigationController.m
//  BWDApp
//
//  Created by Kratos on 15/8/11.
//  Copyright (c) 2015年 Kratos. All rights reserved.
//

#import "KDTNavigationController.h"
#import "RMPZoomTransitionAnimator.h"
#import "UIImage+RXExtension.h"
#import "conf.h"

@interface KDTNavigationController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation KDTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.enabled = NO;
    self.delegate = self;
}

+ (void)initialize
{
    [self setupNavBarTheme];
}

+ (void)setupNavBarTheme
{
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    NSDictionary *textAttributes = nil;
    
    //UIImage *backgroundImage backgroundImage = [UIImage imageNamed:@"nav_backgroud"];
    
    textAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                       NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    //[navigationBarAppearance setTranslucent:NO];
    //[navigationBarAppearance setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    //[navigationBarAppearance setBackgroundImage:backgroundImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setBarTintColor:BTBatteryColor];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    //[navigationBarAppearance setBackgroundColor:BTBatteryColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tb_icon_navigation_back"]
                  style:UIBarButtonItemStyleDone
                 target:self
                 action:@selector(clickBackBarButton:)];
        viewController.navigationItem.leftBarButtonItem = backBarButtonItem;
        [viewController setHidesBottomBarWhenPushed:animated];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)clickBackBarButton:(UIBarButtonItem *)item
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([vc isKindOfClass:[UITabBarController class]])
    {
        [self popViewControllerAnimated:YES];
    }
    else
    {
        [self popToRootViewControllerAnimated:YES];
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    id <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> sourceTransition =
    (id<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)fromVC;
    
    id <RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> destinationTransition =
    (id<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>)toVC;
    
    if ([sourceTransition conformsToProtocol:@protocol(RMPZoomTransitionAnimating)] &&
        [destinationTransition conformsToProtocol:@protocol(RMPZoomTransitionAnimating)]) {
        RMPZoomTransitionAnimator *animator = [[RMPZoomTransitionAnimator alloc] init];
        animator.goingForward = (operation == UINavigationControllerOperationPush);
        animator.sourceTransition = sourceTransition;
        animator.destinationTransition = destinationTransition;
        return animator;
    }
    return nil;
}

@end
