//
//  CYLPlusButtonSubclass.m
//  DWCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 15/10/24.
//  Copyright (c) 2015年 https://github.com/ChenYilong . All rights reserved.
//

#import "KDTPlusButton.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "BTTabBarController.h"
#import "KDTNavigationController.h"

@interface KDTPlusButton () <UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate>{
    CGFloat _buttonImageHeight;
}
@end
@implementation KDTPlusButton

#pragma mark -
#pragma mark - Life Cycle

+(void)load {
    [super registerSubclass];
}

#pragma mark -
#pragma mark - Life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    return [super initWithFrame:frame];
}



#pragma mark -
#pragma mark - Public Methods

/*
 *
 Create a custom UIButton without title and add it to the center of our tab bar
 *
 */
+ (instancetype)plusButton
{

    UIImage *buttonImage = [UIImage imageNamed:@"tab_publish_add"];
    UIImage *highlightImage = [UIImage imageNamed:@"tab_publish_add_pressed"];
    UIImage *iconImage = [UIImage imageNamed:@"tab_publish_add"];
    UIImage *highlightIconImage = [UIImage imageNamed:@"tab_publish_add_pressed"];

    KDTPlusButton *button = [KDTPlusButton buttonWithType:UIButtonTypeCustom];
    
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setImage:iconImage forState:UIControlStateNormal];
    [button setImage:highlightIconImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    //[button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


@end
