//
//  SettingsHeaderView.h
//  KDTUser
//
//  Created by wd on 16/5/9.
//  Copyright © 2016年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsHeaderView : UIView

@property (nonatomic,strong) UIImageView* background;
@property (nonatomic,strong) UIImageView* licenced;
@property (nonatomic,strong) UIImageView* widget;
@property (nonatomic,strong) UILabel* title;
@property (nonatomic,strong) UILabel* button;

-(instancetype) initWithFrame:(CGRect)frame;
-(void) tap:(id)sender;
-(void) updateLicence:(NSDictionary*) licence;

@end
