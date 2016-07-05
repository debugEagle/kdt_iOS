//
//  UIBarButtonItem+Extension.h
//  BWDApp
//
//  Created by Ryan on 15/8/17.
//  Copyright (c) 2015年 Flinkinfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (RXExtension)
/**
 *  返回图片样式导航条Item
 *
 *  @param nmlIme 正常状态的图片
 *  @param hltImg 高度状态的图片
 *  @param target 按钮target
 *  @param action 按钮点击触发方法
 *
 *  @return UIBarButtonItem
 */
+ (instancetype)rx_barBtnItemWithNmlImg:(NSString *)nmlIme
                              hltImg:(NSString *)hltImg
                              target:(id)target
                              action:(SEL)action;

/**
 *  返回文字的导航条item
 *
 *  @param title      文字
 *  @param titleColor 文字颜色
 *  @param titleFont  文字字体
 *  @param target     按钮target
 *  @param action     按钮点击触发方法
 *
 *  @return UIBarButtonItem
 */
+ (instancetype)rx_barBtnItemWithTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                          titleFont:(UIFont *)titleFont
                             target:(id)target
                             action:(SEL)action;
@end
