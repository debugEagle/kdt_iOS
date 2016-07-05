//
//  NVActivityIndicatorAnimationBallScaleRippleMultiple.m
//  AnimationDemo
//
//  Created by 沈文涛 on 15/11/22.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import "NVActivityIndicatorAnimationBallScaleRippleMultiple.h"
#import "NVActivityIndicatorShape.h"

@implementation NVActivityIndicatorAnimationBallScaleRippleMultiple

- (void)setUpAnimationInLayer:(CALayer *)layer size:(CGSize)size color:(UIColor *)color
{
    CFTimeInterval duration = 1.25;
    NSArray *beginTimes = @[@(0.0),@(0.2),@(0.4)];
    CAMediaTimingFunction *timingFunction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.21 :0.53 :0.56 :0.8];
    
    // sacle animation
    CAKeyframeAnimation *scaleAnimation = [[CAKeyframeAnimation alloc] init];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.keyTimes = @[@(0.0),@(0.7)];
    scaleAnimation.timingFunction = timingFunction;
    scaleAnimation.values = @[@(0.0),@(1.0)];
    scaleAnimation.duration = duration;
    
    // Opacity animation
    CAKeyframeAnimation *opacityAnimaiton = [[CAKeyframeAnimation alloc] init];
    opacityAnimaiton.keyPath = @"opacity";
    opacityAnimaiton.keyTimes =  @[@(0.0),@(0.7)];
    opacityAnimaiton.timingFunctions = @[timingFunction,timingFunction];
    opacityAnimaiton.values = @[@(1.0),@(0.7),@(0.0)];
    opacityAnimaiton.duration = duration;
    
    // Animation group
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.animations = @[scaleAnimation,opacityAnimaiton];
    animationGroup.duration = duration;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.removedOnCompletion = NO;
    
    // Draw circles
    for (NSInteger index = 0; index<3; index++) {
        NVActivityIndicatorShape *circle = [[NVActivityIndicatorShape alloc]  initLayerWithShapeType:NVActivityIndicatorShapeTypeRing size:size color:color];
        
        CGRect frame = CGRectMake((layer.bounds.size.width - size.width) / 2,
                                  (layer.bounds.size.height - size.height) / 2,
                                  size.width,
                                  size.height);
        
        animationGroup.beginTime = CACurrentMediaTime() + [beginTimes[index] doubleValue];
        circle.frame = frame;
        [circle addAnimation:animationGroup forKey:@"animation"];
        [layer addSublayer:circle];
    }
}

@end
