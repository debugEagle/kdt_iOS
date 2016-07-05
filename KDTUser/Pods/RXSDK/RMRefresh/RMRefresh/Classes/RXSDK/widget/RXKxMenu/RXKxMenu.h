//
//  EPKxMenu.h
//  EPIMApp
//
//  Created by Ryan on 15/10/19.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RXKxMenu : UIView

/**
 *  点击展示类似气泡的选择菜单
 *
 *  @param view        需要展示到的View
 *  @param targetFrame 目标frame
 *  @param itemsArray  选项按钮数组,里面装的是KxMenuItem对象
 *  
 
    实例代码
 *  KxMenuItem *item1 = [KxMenuItem menuItem:@"扫一扫" 
                                       image:[UIImage imageNamed:@"nav_bar_scan"]
                                      target:self
                                      action:@selector(sacn:)];
 
 *  KxMenuItem *item2 = [KxMenuItem menuItem:@"创建讨论组"
                                       image:[UIImage imageNamed:@"nav_bar_group_add"]
                                      target:self
                                      action:@selector(createDisccsionGroup:)];
 
 *  NSArray *itemsArray = @[item1,item2];
 
 *  CGRect targetFrame = self.navigationItem.rightBarButtonItem.customView.frame;
 *  targetFrame.origin.y = targetFrame.origin.y - 10;
 *  [EPKxMenu showWithView:self.view fromRect:targetFrame menuItemsArray:itemsArray];
 */
+ (void)showWithView:(UIView *)view
            fromRect:(CGRect )targetFrame
      menuItemsArray:(NSArray *)itemsArray;

@end
