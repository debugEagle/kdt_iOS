//
//  HyTransitions.h
//  Example
//
//  Created by  东海 on 15/9/2.
//  Copyright (c) 2015年 Jonathan Tribouharet. All rights reserved.
//  转场动画

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HyTransitions : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionDuration:(NSTimeInterval)transitionDuration
                             startingAlpha:(CGFloat)startingAlpha
                                    isBOOL:(BOOL)is;

@end
