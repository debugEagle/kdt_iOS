//
//  BTHomePageHeaderView.m
//  BanTang
//
//  Created by Ryan on 15/11/27.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "conf.h"
#import "KDtHomeHeaderView.h"
#import "UIView+Frame.h"
#import <SDCycleScrollView.h>


@interface KDtHomeHeaderView() <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UIView *diverLine;

@end

@implementation KDtHomeHeaderView

-(instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.cycleScrollView];
        //[self addSubview:self.diverLine];
    }
    return self;
}

#pragma SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(headerView:didClickBannerViewWithIndex:)]) {
        [self.delegate headerView:self didClickBannerViewWithIndex:index];
    }
}


#pragma mark - Setter
// 设置轮播图图片数组
- (void)setImages:(NSArray *)images
{
    self.cycleScrollView.imageURLStringsGroup = [images copy];
}

#pragma mark - Getter
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        CGRect rect = {0, 0, self.bounds.size.width, self.bounds.size.height - 8};
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:rect imageURLStringsGroup:@[]];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.layer.cornerRadius = 5.0f;
    }
    return _cycleScrollView;
}


- (UIView *)diverLine
{
    if (!_diverLine) {
        CGRect rect = {0, self.bounds.size.height - 8, self.bounds.size.width, 0};
        _diverLine = [[UIView alloc] initWithFrame:rect];
        _diverLine.backgroundColor = BTBackgroundColor;
    }
    return _diverLine;
}


@end
