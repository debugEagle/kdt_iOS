//
//  NVActivityIndicatorAnimationDelegate.h
//  AnimationDemo
//
//  Created by 沈文涛 on 15/11/22.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NVActivityIndicatorAnimationDelegate <NSObject>
- (void)setUpAnimationInLayer:(CALayer *)layer size:(CGSize)size color:(UIColor *)color;
@end
