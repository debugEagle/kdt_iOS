//
//  AppBundleView.h
//  MulitfyTest
//
//  Created by wd on 15-9-10.
//
//

#import <UIKit/UIKit.h>
#import "KDTWindow.h"

#define HostViewName @"WDFBSceneHostView"

@interface KDTNotifyView : UIView

@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) NSMutableArray* saveConstraints;

- (id) init;

- (void) show;
- (void) hide;

- (void) didAddSubview:(UIView *)subview;
- (void) willRemoveSubview:(UIView *)subview;

- (void) showText:(NSString*) text;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end
