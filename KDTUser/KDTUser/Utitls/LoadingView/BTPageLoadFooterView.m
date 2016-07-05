//
//  BTPageLoadFooterView.m
//  BanTang
//
//  Created by Ryan on 15/12/7.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "BTPageLoadFooterView.h"
#import "conf.h"

@interface BTPageLoadFooterView()


@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, weak) UIView *logoView;
@property (nonatomic, weak) UIImageView *footerLogoView;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, copy) FooterRefreshBlock footerRefreshBlock;

@end

@implementation BTPageLoadFooterView

+ (instancetype)footerWithRefreshingBlock:(FooterRefreshBlock)footerRefreshBlock
{
    BTPageLoadFooterView *footerView = [[self alloc] init];
    footerView.footerRefreshBlock = footerRefreshBlock;
    return footerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        UIView *logoView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:logoView];
        self.logoView = logoView;
        //UIImageView *footerLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bottom_logo"]];
        //[footerLogoView setCenter:CGPointMake(self.center.x, footerLogoView.center.y)];
        //[self.logoView addSubview:footerLogoView];
        //self.footerLogoView = footerLogoView;
    
        [self addSubview:self.imageView];
    }
    return self;
}

-(void) setRefreshBlock:(FooterRefreshBlock)block {
    self.footerRefreshBlock = block;
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


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:(CGRect)CGRectMake(0, 0, 40, 7)];
         [_imageView setCenter:CGPointMake(self.center.x, self.center.y - 30)];
    }
    return _imageView;
}


- (void)startRefreshing
{
    if (self.imageView.isAnimating) return;
    
    [self.logoView setHidden:YES];
    self.imageView.animationImages = self.imagesArray;
    self.imageView.animationDuration = 1.0f;
    self.imageView.animationRepeatCount = HUGE;
    [self.imageView startAnimating];
    
    if (self.footerRefreshBlock) {
        self.footerRefreshBlock();
    }
}

- (void)endRefreshing{
    if (!self.imageView.isAnimating)  return;
    
    [self.logoView setHidden:NO];
    [self.imageView stopAnimating];
}
@end
