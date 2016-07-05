//
//  EPCoreLaunchLite.h
//  EPIMApp
//
//  Created by Ryan on 15/11/16.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RXCoreLaunchLite : NSObject

/**
 *  本方法用于启动的时候界面动画,需要将启动界面的图片命名好之后在拖进去Asset里面,而非启动界面里
 */
+ (void)animWithWindow:(UIWindow *)window image:(UIImage *)image;

@end
