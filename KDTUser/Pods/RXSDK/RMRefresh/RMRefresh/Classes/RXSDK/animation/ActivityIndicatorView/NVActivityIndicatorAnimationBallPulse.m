//
//  NVActivityIndicatorAnimationBallPulse.m
//  AnimationDemo
//
//  Created by 沈文涛 on 15/11/22.
//  Copyright © 2015年 RyanShen. All rights reserved.
/**
 *  这个动画主要是靠scale进行缩放,1->0.3->1,时间在0.12秒的间隔,执行通话即可
 */

#import "NVActivityIndicatorAnimationBallPulse.h"
#import "NVActivityIndicatorShape.h"

@implementation NVActivityIndicatorAnimationBallPulse

- (void)setUpAnimationInLayer:(CALayer *)layer size:(CGSize)size color:(UIColor *)color
{
    CGFloat circleSpacing = 2;
    CGFloat circleSize = (size.width - 2*circleSpacing) / 3;
    CGFloat x = (layer.bounds.size.width - size.width)  / 2;
    CGFloat y = (layer.bounds.size.height - circleSize) / 2;
    CFTimeInterval duration = 0.75;
    NSArray *array = @[@(0.24),@(0.36),@(0.48)];
    CAMediaTimingFunction *function = [[CAMediaTimingFunction alloc] initWithControlPoints:0.2 :0.68 :0.18 :1.08];
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.keyPath = @"transform.scale";
    
    // Animation
    animation.keyTimes = @[@(0),@(0.3),@(1)];
    animation.timingFunctions = @[function,function];
    animation.values = @[@(1),@(0.3),@(1)];
    animation.duration = duration;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    
    for (NSInteger index = 0; index < 3; index++)
    {
        NVActivityIndicatorShape *circle =
        [[NVActivityIndicatorShape alloc] initLayerWithShapeType:NVActivityIndicatorShapeTypeCircle
                                                            size:CGSizeMake(circleSize, circleSize)
                                                           color:color];
        
        CGRect frame = CGRectMake(x + (circleSize + circleSpacing)* index,
                                  y,
                                  circleSize,
                                  circleSize);
        
        animation.beginTime = CACurrentMediaTime() + [array[index] doubleValue];
        circle.frame = frame;
        [circle addAnimation:animation forKey:@"animation"];
        [layer addSublayer:circle];
    }
}

@end
