//
//  KDTNewCell.h
//  KDTUser
//
//  Created by wd on 16/5/3.
//  Copyright © 2016年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDTNewCell : UITableViewCell

@property (nonatomic,strong) UIView* container;
@property (nonatomic,strong) UILabel* game;
@property (nonatomic,strong) UIImageView* type;
@property (nonatomic,strong) UILabel* author;
@property (nonatomic,strong) UILabel* time;
@property (nonatomic,strong) UILabel* title;
@property (nonatomic,strong) UILabel* describe;
@property (nonatomic,strong) UIImageView* image1;
@property (nonatomic,strong) UIImageView* image2;
@property (nonatomic,strong) UIImageView* image3;
@property (nonatomic,retain) NSDictionary* doc;
@property (nonatomic,strong) id delegate;

@property (nonatomic,strong) NSMutableArray* saveConstraints;

+ (CGFloat) heightWithContent:(NSDictionary*) doc;

- (void) renderWithContent:(NSDictionary*) doc;

@end
