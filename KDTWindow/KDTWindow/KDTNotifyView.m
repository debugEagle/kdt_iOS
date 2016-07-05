//
//  AppBundleView.m
//  MulitfyTest
//
//  Created by wd on 15-9-10.
//
//

#import "KDTNotifyView.h"
#import <objc/runtime.h>

#define noerr

#ifdef noerr
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
#endif

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@implementation KDTNotifyView


- (id) init {
    WDLog(".");
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}

- (void) setup {
    _label = [[UILabel alloc] initWithFrame:self.frame];
    _label.text = @"";
    _label.font = [UIFont systemFontOfSize:14.f];
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = [UIColor blackColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.layer.cornerRadius = 5.f;
    _label.layer.masksToBounds = YES;
    _label.numberOfLines = 0;
    _label.alpha = 0.9f;
    _label.hidden = YES;
    _label.center = self.center;
    [self addSubview:_label];
}

- (void)didAddSubview:(UIView *)subview {
    WDLog("%@", subview);
}


- (void)willRemoveSubview:(UIView *)subview {
    WDLog("%@", subview);
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
    {
        return nil;
    }
    else
    {
        return hitView;
    }
}


- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
}


- (void) updateConstraints {

    [super updateConstraints];
}


-(void) hideText {
    self.label.text = @"";
    self.label.hidden = YES;
}


- (void) showText:(NSString*) text {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.label.text = text;
    self.label.hidden = NO;
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 40.f, kScreenHeight - 60.f)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                  attributes:@{NSFontAttributeName: self.label.font}
                                     context:nil];
    
    if (rect.size.width < 80) rect.size.width = 80;
    
    [self.label setBounds:CGRectMake(0, 0, rect.size.width + 20, rect.size.height + 10)];
    self.label.transform = CGAffineTransformMakeScale(0.1, 0.1);
    __block typeof(self) that = self;
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0.0 options:
     UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{that.label.transform = CGAffineTransformMakeScale(1, 1);}
                     completion:^(BOOL finished){}
     ];
    [self performSelector:@selector(hideText) withObject:NO afterDelay:2.0];
}

- (void) show {
    self.hidden = NO;
}

- (void) hide {
    self.hidden = YES;
}


#ifdef noerr
#pragma clang diagnostic pop
#endif

@end
