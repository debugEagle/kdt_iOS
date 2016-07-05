//
//  BTLoadingView.h
//  BanTang
//
//  Created by Ryan on 15/11/27.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTLoadingView : UIView


+ (instancetype)loadingViewToView:(UIView *)toView;

- (void)startAnimation;

- (void)hideAnimation;

@end
