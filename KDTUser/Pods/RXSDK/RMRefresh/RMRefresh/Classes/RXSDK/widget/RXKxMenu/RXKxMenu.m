//
//  EPKxMenu.m
//  EPIMApp
//
//  Created by Ryan on 15/10/19.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "RXKxMenu.h"
#import "NirKxMenu.h"

@implementation RXKxMenu

+ (void)showWithView:(UIView *)view fromRect:(CGRect )targetFrame menuItemsArray:(NSArray *)itemsArray
{
    //配置一：基础配置
    [KxMenu setTitleFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    
    //配置二：拓展配置
    
    OptionalConfiguration options;
    
    options.arrowSize = 9;          //指示箭头大小
    options.marginXSpacing = 7;     //MenuItem左右边距
    options.marginYSpacing = 9;     //MenuItem上下边距
    options.intervalSpacing = 25;   //MenuItemImage与MenuItemTitle的间距
    options.menuCornerRadius = 6.5; //菜单圆角半径
    options.maskToBackground = YES; //是否添加覆盖在原View上的半透明遮罩
    options.shadowOfMenu = NO;      //是否添加菜单阴影
    options.hasSeperatorLine = YES; //是否设置分割线
    options.seperatorLineHasInsets = NO;  //是否在分割线两侧留下Insets
    
    Color textColor;
    
    textColor.R = 0;
    textColor.G = 0;
    textColor.B = 0;
    
    options.textColor = textColor;        //menuItem字体颜色
    
    Color menuBgColor;
    
    menuBgColor.R = 1;
    menuBgColor.G = 1;
    menuBgColor.B = 1;
    
    options.menuBackgroundColor = menuBgColor;   //菜单的底色
    
    [KxMenu showMenuInView:view fromRect:targetFrame menuItems:itemsArray withOptions:options];
}
@end
