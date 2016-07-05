//
//  BTLoadingView.m
//  BanTang
//
//  Created by Ryan on 15/11/27.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "BTLoadingView.h"
#import "conf.h"

@interface BTLoadingView()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation BTLoadingView


+ (instancetype)loadingViewToView:(UIView *)toView;
{
    return [[self alloc] initWithFrame:toView.frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (frame.size.width == 0) {
        frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    }
    CGFloat h = 9;
    CGFloat w = 52.5;
    CGFloat x = (frame.size.width - w) * 0.5;
    CGFloat y = (frame.size.height - h) * 0.5;
    self.frame = CGRectMake(x, y, w, h);
    
    if (self)
    {
        [self addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        // 4.3版本
//        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.bounds;
    }
    return _imageView;
}

/**
 *  版本5.0的动画
 */
// 开始动画
- (void)startAnimation
{
    self.hidden = false;
    
    if (self.imageView.isAnimating) return;

    self.imageView.animationImages = self.imagesArray;
    self.imageView.animationDuration = 1.0f;
    self.imageView.animationRepeatCount = HUGE;
    [self.imageView startAnimating];
}
// 隐藏动画
- (void)hideAnimation{
    if (!self.imageView.isAnimating)  return;
    self.hidden = true;
    [self.imageView stopAnimating];
    [self.imagesArray removeAllObjects];
    self.imagesArray = nil;
    self.imageView = nil;
}

/**
 *  版本4.3的动画
 */
//- (void)startAnimation
//{
//    self.hidden = false;
//    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotate.fromValue = 0;
//    rotate.toValue = @(M_PI * 2);
//    rotate.duration = 0.75;
//    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    rotate.repeatCount = HUGE;
//    rotate.fillMode = kCAFillModeForwards;
//    rotate.removedOnCompletion = false;
//    [self.imageView.layer addAnimation:rotate forKey:@"animtaion"];
//}

//- (void)hideAnimation{
//    self.hidden = true;
//    
//    [self.imageView.layer removeAllAnimations];
//}

- (NSMutableArray *)imagesArray
{
    if (!_imagesArray)
    {
        _imagesArray = [NSMutableArray array];
        for (NSInteger index = 1; index <= 21; index++) {
            NSString *imageName = [NSString stringWithFormat:@"loading%zd",index];
            UIImage *loadingImage = [UIImage imageNamed:imageName];
            [_imagesArray addObject:loadingImage];
        }
    }
    return _imagesArray;
}

- (void)dealloc
{
    NSLog(@"loadingViewDealloc");
}

@end
