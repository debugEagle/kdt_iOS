//
//  NVActivityIndicatorAnimationBallSpinFadeLoader.m
//  AnimationDemo
//
//  Created by 沈文涛 on 15/11/23.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import "NVActivityIndicatorAnimationBallSpinFadeLoader.h"
#import "NVActivityIndicatorShape.h"

@implementation NVActivityIndicatorAnimationBallSpinFadeLoader

- (void)setUpAnimationInLayer:(CALayer *)layer size:(CGSize)size color:(UIColor *)color
{
    CGFloat circleSapcing = 2;
    CGFloat circleSizeW = (size.width + 4*circleSapcing) / 5;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    CFTimeInterval duration = 1;
    NSArray *beginTimes = @[@(0.0),@(0.12),@(0.24),@(0.36),@(0.48),@(0.6),@(0.72),@(0.84)];
    
    // scale animation
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.keyTimes = @[@(0.0),@(0.5),@(1.0)];
    scaleAnimation.values = @[@(1.0),@(0.3),@(1.0)];
    scaleAnimation.duration = duration;
    
    // opacity animation
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.keyTimes = @[@(0.0),@(0.5),@(1.0)];
    opacityAnimation.values = @[@(1.0),@(0.3),@(1.0)];
    opacityAnimation.duration = duration;
    
    // animation group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation,opacityAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.removedOnCompletion = NO;
    animationGroup.duration = duration;
    
    for (NSInteger index = 0; index < 8; index++)
    {
        CALayer *circle = [self circleAt:(M_PI_4 * index)
                                    size:circleSizeW
                                  origin:CGPointMake(x, y)
                           containerSize:size
                                   color:color];
        
        animationGroup.beginTime = CACurrentMediaTime() + [beginTimes[index] doubleValue];
        [circle addAnimation:animationGroup forKey:@"animation"];
        [layer addSublayer:circle];
    }
}

- (CALayer *)circleAt:(CGFloat)angle
                 size:(CGFloat)size
               origin:(CGPoint)origin
        containerSize:(CGSize)containerSize
                color:(UIColor *)color
{
    CGFloat radius = containerSize.width / 2;
    NVActivityIndicatorShape *shape = [[NVActivityIndicatorShape alloc] initLayerWithShapeType:NVActivityIndicatorShapeTypeCircle size:CGSizeMake(size, size) color:color];
    CGFloat x = origin.x + radius * (cos(angle) + 1) - size / 2;
    CGFloat y = origin.y + radius * (sin(angle) + 1) - size / 2;
    
    CGRect frame = CGRectMake(x, y, size, size);
    shape.frame = frame;
    return shape;
}

@end
