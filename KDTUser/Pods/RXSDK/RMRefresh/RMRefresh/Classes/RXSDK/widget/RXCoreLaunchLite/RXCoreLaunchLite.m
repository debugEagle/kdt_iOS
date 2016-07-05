//
//  EPCoreLaunchLite.m
//  EPIMApp
//
//  Created by Ryan on 15/11/16.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "RXCoreLaunchLite.h"
#import "RXMarco.h"

@implementation RXCoreLaunchLite

/** 执行动画 */
+ (void)animWithWindow:(UIWindow *)window image:(UIImage *)image{
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    imageV.image = image==nil?[self launchImage]:image;
    
    [window.rootViewController.view addSubview:imageV];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1 animations:^{
            
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            imageV.transform=CGAffineTransformMakeScale(1.5f, 1.5f);
            imageV.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            [imageV removeFromSuperview];
        }];
    });
}


/**
 *  获取启动图片
 */
+ (UIImage *)launchImage{
    
    // 下面的名字需要对应好
    NSString *imageName=@"lunch-640x960";
    
    if(rx_iPhone5) imageName=@"lunch-640x1136";
    
    if(rx_iPhone6) imageName = @"lunch-750x1334";
    
    if(rx_iPhone6P) imageName = @"lunch-1242x2208";
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    NSAssert(image != nil, @"Charlin Feng提示您：请添加启动图片！");
    
    return image;
}


@end
