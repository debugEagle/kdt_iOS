//
//  NVActivityIndicatorAnimationBallClipRotate.m
//  AnimationDemo
//
//  Created by Ryan on 15/11/24.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import "NVActivityIndicatorAnimationBallClipRotate.h"
#import "NVActivityIndicatorShape.h"
@implementation NVActivityIndicatorAnimationBallClipRotate

- (void)setUpAnimationInLayer:(CALayer *)layer size:(CGSize)size color:(UIColor *)color
{
    // scale animation
    CGFloat duration = 0.75;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.keyTimes = @[@(0),@(0.5),@(1)];
    scaleAnimation.values = @[@(1),@(0.6),@(1)];
    
    // transform.rotate.z
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.keyTimes = @[@(0),@(0.5),@(1)];
    rotateAnimation.values = @[@(0),@(M_PI),@(2 * M_PI)];
    
    // animaiton group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation,rotateAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.duration = duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.repeatCount = MAXFLOAT;
    
    NVActivityIndicatorShape *circle = [[NVActivityIndicatorShape alloc] initLayerWithShapeType:NVActivityIndicatorShapeTypeRingThirdFour size:size color:color];
    CGFloat centerX = (layer.bounds.size.width - size.width ) *0.5;
    CGFloat centerY = (layer.bounds.size.height - size.height) * 0.5;
    circle.frame = CGRectMake(centerX, centerY, size.width, size.height);
    [circle addAnimation:animationGroup forKey:@"animation"];
    [layer addSublayer:circle];
}

@end
