//
//  BTHomePageHeaderView.h
//  BanTang
//
//  Created by Ryan on 15/11/27.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDtHomeHeaderView;

@protocol KDtHomeHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(KDtHomeHeaderView *)headerView didClickBannerViewWithIndex:(NSInteger)index;

@end

@interface KDtHomeHeaderView : UIView

@property (nonatomic, weak) id <KDtHomeHeaderViewDelegate> delegate;

-(instancetype) initWithFrame:(CGRect)frame;

- (void)setImages:(NSArray *)images;

@end
