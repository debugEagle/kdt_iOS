//
//  NVActivityIndicatorShape.m
//  AnimationDemo
//
//  Created by 沈文涛 on 15/11/22.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import "NVActivityIndicatorShape.h"
static CGFloat const lineWidth = 2;
@interface NVActivityIndicatorShape()

@property (nonatomic, strong) CAShapeLayer *layer;

@property (nonatomic, strong) UIBezierPath *myPath;

@end

@implementation NVActivityIndicatorShape

- (CAShapeLayer *)initLayerWithShapeType:(NVActivityIndicatorShapeType)type size:(CGSize)size color:(UIColor *)color
{
    switch (type)
    {
        case NVActivityIndicatorShapeTypeCircle:
        {
            [self.myPath addArcWithCenter:CGPointMake(size.width / 2, size.height / 2)
                                   radius:size.width / 2
                               startAngle:0
                                 endAngle:(2 * M_PI)
                                clockwise:NO];
            
            self.layer.fillColor = color.CGColor;
        }
            break;
        case NVActivityIndicatorShapeTypeRing:
        {
            [self.myPath addArcWithCenter:CGPointMake(size.width / 2, size.height / 2)
                                   radius:size.width / 2
                               startAngle:0
                                 endAngle:(2 * M_PI)
                                clockwise:NO];
            self.layer.fillColor = nil;
            self.layer.strokeColor = color.CGColor;
            self.layer.lineWidth = lineWidth;
        }
            break;
        case NVActivityIndicatorShapeTypeRingThirdFour:
        {
            [self.myPath addArcWithCenter:CGPointMake(size.width / 2, size.height / 2)
                                   radius:size.width / 2
                               startAngle: M_PI_4
                                 endAngle:3 * M_PI_4
                                clockwise:NO];
            self.layer.fillColor = nil;
            self.layer.strokeColor = color.CGColor;
            self.layer.lineWidth = lineWidth;
        }
            break;
        case NVActivityIndicatorShapeTypePacman:
        {
            [self.myPath addArcWithCenter:CGPointMake(size.width / 2, size.height / 2)
                                   radius:size.width / 2
                               startAngle:- (5/12) * M_PI
                                 endAngle:- (23/36) * M_PI
                                clockwise:NO];
            self.layer.fillColor = nil;
            self.layer.strokeColor = color.CGColor;
            self.layer.lineWidth = lineWidth;
        }
            break;

        default:
            break;
    }
    
    self.layer.backgroundColor = nil;
    self.layer.path = self.myPath.CGPath;
    return (NVActivityIndicatorShape *)self.layer;
}

- (UIBezierPath *)myPath
{
    if (!_myPath) {
        _myPath = [UIBezierPath bezierPath];
    }
    return _myPath;
}

- (CAShapeLayer *)layer{
    if (!_layer) {
        _layer = [CAShapeLayer layer];
    }
    return _layer;
}

@end
