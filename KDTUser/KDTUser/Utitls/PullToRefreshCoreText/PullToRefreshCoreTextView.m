//
//  PullToRefreshCoreTextView.m
//  PullToRefreshCoreText
//
//  Created by Cem Olcay on 14/10/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import "PullToRefreshCoreTextView.h"

@implementation NSString (Glyphs)

- (UIBezierPath*)bezierPathWithFont:(UIFont*)font {
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:self attributes:[NSDictionary dictionaryWithObject:(__bridge id)ctFont forKey:(__bridge NSString*)kCTFontAttributeName]];
    CFRelease(ctFont);
    
    CGMutablePathRef letters = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributed);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    CGRect boundingBox = CGPathGetBoundingBox(letters);
    CGPathRelease(letters);
    CFRelease(line);
    
    // The path is upside down (CG coordinate system)
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    return path;
}

@end


@implementation PullToRefreshCoreTextView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                     pullText:(NSString *)pullText
                pullTextColor:(UIColor *)pullTextColor
                 pullTextFont:(UIFont *)pullTextFont
               refreshingText:(NSString *)refreshingText
          refreshingTextColor:(UIColor *)refreshingTextColor
           refreshingTextFont:(UIFont *)refreshingTextFont
                 beforeAction:(pullToRefreshAction) before
                  startAction:(pullToRefreshAction) start
                  afterAction:(pullToRefreshAction) after;{
    if ((self = [super initWithFrame:frame])) {
        
        _pullText = pullText;
        _pullTextColor = pullTextColor;
        _pullTextFont = pullTextFont;
        
        _refreshingText = refreshingText;
        _refreshingTextColor = refreshingTextColor;
        _refreshingTextFont = refreshingTextFont;
        
        self.beforeAction = before;
        self.startAction = start;
        self.afterAction = after;
    
        _imageView = [[UIImageView alloc] initWithFrame:(CGRect)CGRectMake(0, 0, 40, 7)];
        [_imageView setCenter:CGPointMake(self.center.x + 10, self.center.y + 12)];
        _imageView.animationImages = self.imagesArray;
        _imageView.animationDuration = 1.0f;
        _imageView.animationRepeatCount = HUGE;
        
        [self.layer addSublayer:_imageView.layer];
        [self.layer addSublayer:self.pullTextLayer];
    
        self.status = PullToRefreshCoreTextStatusHidden;
        self.loading = NO;
        
        self.triggerOffset = self.frame.size.height;
        self.triggerThreshold = self.frame.size.height;
    }
    return self;
}


-(void) setPullText:(NSString*) text {
    _pullText = text;
    self.layer.sublayers = nil;
    CATextLayer* layer = self.pullTextLayer;
    float textSize = [text sizeWithAttributes:@{NSFontAttributeName:self.refreshingTextFont}].width;
    [layer setPosition:CGPointMake(self.frame.size.width - (textSize / 2), 0)];
    [layer setString:text];
    CALayer *maskLayer = [CALayer layer];
    
    maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3] CGColor];
    maskLayer.contents = (id)[[UIImage imageNamed:@"Mask.png"] CGImage];
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(self.frame.size.width * -1, 0.0f, self.frame.size.width * 2, self.frame.size.height);
    layer.mask = maskLayer;
    
    CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    maskAnim.byValue = [NSNumber numberWithFloat:self.frame.size.width];
    maskAnim.repeatCount = HUGE_VALF;
    maskAnim.duration = 2.0f;
    [maskLayer addAnimation:maskAnim forKey:@"slideAnim"];
    [self.layer addSublayer:self.pullTextLayer];
}

#pragma mark - Logic


- (void)startLoading {
    self.loading = YES;
    [self startAnimation];
    self.startAction();
}

- (void)endLoading {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endLoading) object:nil];
    self.loading = NO;
    [self hideAnimation];
    if (self.scrollView.contentInset.top > 0) {
        [UIView animateWithDuration:0.4 animations:^{
            self.scrollView.contentInset = _oldUIEdgeInsets;
        } completion:^(BOOL finished){
            self.afterAction();
        }];
    }
}


- (CATextLayer *)pullTextLayer {
    if (!_pullTextLayer) {
        CATextLayer *text = [[CATextLayer alloc] init];
        [text setFrame:self.bounds];
        [text setString:(id)self.refreshingText];
        [text setFont:CTFontCreateWithName((__bridge CFStringRef)self.refreshingTextFont.fontName, self.refreshingTextFont.pointSize, NULL)];
        [text setFontSize:self.refreshingTextFont.pointSize];
        [text setForegroundColor:[self.refreshingTextColor CGColor]];
        [text setContentsScale:[[UIScreen mainScreen] scale]];
        float textSize = [self.refreshingText sizeWithAttributes:@{NSFontAttributeName:self.refreshingTextFont}].width;
        [text setPosition:CGPointMake(self.frame.size.width - textSize / 2, 0)];
        _pullTextLayer = text;
    }
    return _pullTextLayer;
}

#pragma mark - Interaction

- (void)scrollViewDidScroll:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        CGFloat offset = self.scrollView.contentOffset.y;
        if (offset <= 0) self.beforeAction ();
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (self.isLoading)
            return;
        
        CGFloat offset = self.scrollView.contentOffset.y + self.triggerThreshold;
        if (offset <= 0) {
            
            CGFloat fractionDragged = -offset/self.triggerOffset;
            [(CALayer *)[self.layer.sublayers firstObject] setTimeOffset:MIN(1, fractionDragged)];
            if (fractionDragged >= 1) {
                self.status = PullToRefreshCoreTextStatusTriggered;
            } else {
                self.status = PullToRefreshCoreTextStatusDragging;
            }
            
        } else {
            self.status = PullToRefreshCoreTextStatusHidden;
        }
    }
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (self.status == PullToRefreshCoreTextStatusTriggered && !self.loading) {
            [self startLoading];
            _oldUIEdgeInsets = self.scrollView.contentInset;
            [UIView animateWithDuration:0.4 animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(self.triggerOffset + self.triggerThreshold, 0, 0, 0)];
            }];
        }
    }
}

- (void)startAnimation
{
    self.layer.sublayers = nil;
    [self.layer addSublayer:self.imageView.layer];
    if (self.imageView.isAnimating) return;
    [self.imageView startAnimating];
}


- (void)hideAnimation {
    if (!self.imageView.isAnimating)  return;
    [self.imageView stopAnimating];
}

- (NSMutableArray *)imagesArray
{
    if (!_imagesArray)
    {
        _imagesArray = [NSMutableArray array];
        for (NSInteger index = 1; index <= 21; index++) {
            NSString *imageName = [NSString stringWithFormat:@"loading%zd",index];
            UIImage *loadingImage = [UIImage imageNamed:imageName];
            [_imagesArray addObject:loadingImage];
        }
    }
    return _imagesArray;
}

#pragma mark - Properties

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    [self.scrollView.panGestureRecognizer addTarget:self action:@selector(scrollViewDidScroll:)];
}

@end
