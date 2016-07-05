//
//  NVActivityIndicatorShape.h
//  AnimationDemo
//
//  Created by 沈文涛 on 15/11/22.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NVActivityIndicatorShapeType)
{
    NVActivityIndicatorShapeTypeCircle  = 0,
    NVActivityIndicatorShapeTypeRing,
    NVActivityIndicatorShapeTypeCircleSemi,
    NVActivityIndicatorShapeTypeRingTwoHalfVertical ,
    NVActivityIndicatorShapeTypeRingTwoHalfHorizontal,
    NVActivityIndicatorShapeTypeRingThirdFour,
    NVActivityIndicatorShapeTypeRectangle,
    NVActivityIndicatorShapeTypeTriangle,
    NVActivityIndicatorShapeTypeLine,
    NVActivityIndicatorShapeTypePacman
};

@interface NVActivityIndicatorShape : CAShapeLayer

- (CAShapeLayer *)initLayerWithShapeType:(NVActivityIndicatorShapeType)type
                                    size:(CGSize)size
                                   color:(UIColor *)color;

@property (nonatomic,assign) NVActivityIndicatorShapeType type;

@end
