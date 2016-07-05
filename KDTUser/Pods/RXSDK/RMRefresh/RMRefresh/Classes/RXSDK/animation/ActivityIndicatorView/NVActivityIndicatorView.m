//
//  NVActivityIndicatorView.m
//  AnimationDemo
//
//  Created by 沈文涛 on 15/11/22.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import "NVActivityIndicatorView.h"
#import "NVActivityIndicatorShape.h"
#import "NVActivityIndicatorAnimationBallPulse.h"
#import "NVActivityIndicatorAnimationBallScaleRippleMultiple.h"
#import "NVActivityIndicatorAnimationBallSpinFadeLoader.h"
#import "NVActivityIndicatorAnimationBallClipRotate.h"

#define DEFAULT_COLOR  [UIColor whiteColor]
#define DEFAULT_SIZE    CGSizeMake(40, 40)

@interface NVActivityIndicatorView ()

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) BOOL animating;

@property (nonatomic, assign) BOOL hidesWhenStopped;

@end

@implementation NVActivityIndicatorView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.color = DEFAULT_COLOR;
        self.size  = DEFAULT_SIZE;
//        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)startAnimation
{
    if (self.hidesWhenStopped && self.hidden) {
        self.hidden = NO;
    }
    
    if (self.layer.sublayers == nil) {
        [self setupAnimation];
    }
    self.layer.speed = 1;
    self.animating = YES;
}

- (void)stopAnimation
{
    self.layer.speed = 0;
    self.animating = NO;
    if (self.hidesWhenStopped && !self.hidden) {
        self.hidden = YES;
    }
}

- (void)setupAnimation
{
    id <NVActivityIndicatorAnimationDelegate>animation = nil;
    switch (self.type) {
        case NVActivityIndicatorTypeBallPulse:
        {
           animation = [[NVActivityIndicatorAnimationBallPulse alloc] init];
        }
            break;
        case NVActivityIndicatorTypeBallScaleMultiple:
        {
            animation = [[NVActivityIndicatorAnimationBallScaleRippleMultiple alloc] init];
        }
            break;
        case NVActivityIndicatorTypeBallSpinFadeLoader:
        {
            animation = [[NVActivityIndicatorAnimationBallSpinFadeLoader alloc] init];
        }
            break;
        case NVActivityIndicatorTypeBallClipRotate:
        {
            animation = [[NVActivityIndicatorAnimationBallClipRotate alloc] init];
        }
            break;
        default:
            break;
    }
    
    self.layer.sublayers = nil;
    [animation setUpAnimationInLayer:self.layer size:self.size color:self.color];
}

@end
