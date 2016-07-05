//
//  NVActivityIndicatorViewNVActivityIndicatorTypeh
//  AnimationDemo
//
//  Created by 沈文涛 on 15/11/22NVActivityIndicatorType
//  Copyright © 2015年 RyanShenNVActivityIndicatorType All rights reservedNVActivityIndicatorType
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NVActivityIndicatorType)
{
    NVActivityIndicatorTypeBallPulse   = 0,
    NVActivityIndicatorTypeBallGridPulse,
    NVActivityIndicatorTypeBallClipRotate,
    NVActivityIndicatorTypeBallClipRotatePulse,
    NVActivityIndicatorTypeSquareSpin,
    NVActivityIndicatorTypeBallClipRotateMultiple,
    NVActivityIndicatorTypeBallPulseRise,
    NVActivityIndicatorTypeBallRotate,
    NVActivityIndicatorTypeCubeTransition,
    NVActivityIndicatorTypeBallZigZag,
    NVActivityIndicatorTypeBallZigZagDeflect,
    NVActivityIndicatorTypeBallTrianglePath,
    NVActivityIndicatorTypeBallScale,
    NVActivityIndicatorTypeLineScale,
    NVActivityIndicatorTypeLineScaleParty,
    NVActivityIndicatorTypeBallScaleMultiple,
    NVActivityIndicatorTypeBallPulseSync,
    NVActivityIndicatorTypeBallBeat,
    NVActivityIndicatorTypeLineScalePulseOut,
    NVActivityIndicatorTypeLineScalePulseOutRapid,
    NVActivityIndicatorTypeBallScaleRipple,
    NVActivityIndicatorTypeBallScaleRippleMultiple,
    NVActivityIndicatorTypeBallSpinFadeLoader,
    NVActivityIndicatorTypeLineSpinFadeLoader,
    NVActivityIndicatorTypeTriangleSkewSpin,
    NVActivityIndicatorTypePacman,
    NVActivityIndicatorTypeBallGridBeat,
    NVActivityIndicatorTypeSemiCircleSpin
};

@interface NVActivityIndicatorView : UIView
- (void)startAnimation;
- (void)stopAnimation;
@property (nonatomic,assign) NVActivityIndicatorType type;

@end
