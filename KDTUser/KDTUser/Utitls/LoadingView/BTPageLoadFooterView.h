//
//  BTPageLoadFooterView.h
//  BanTang
//
//  Created by Ryan on 15/12/7.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FooterRefreshBlock)();

@interface BTPageLoadFooterView : UIView

+ (instancetype)footerWithRefreshingBlock:(FooterRefreshBlock)footerRefreshBlock;

-(void) setRefreshBlock:(FooterRefreshBlock)block;

- (void)startRefreshing;

- (void)endRefreshing;

@end
