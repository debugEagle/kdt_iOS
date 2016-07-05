//
//  cell.h
//  ui
//
//  Created by wd on 15-6-21.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScpViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView* icon;
@property (nonatomic,strong) UILabel* name;
@property (nonatomic,strong) UIImageView* set;
@property (nonatomic,strong) UIImageView* many;
@property (nonatomic,strong) UIImageView* line;
@property (nonatomic,strong) UILabel* descriptor;
@property (nonatomic,strong) UILabel* author;
@property (nonatomic,strong) UILabel* time;
@property (nonatomic,strong) UILabel* ver;

@property (nonatomic,strong) NSMutableArray* saveConstraints;

- (void) renderWithContent:(NSDictionary*) doc;

- (void) setSelect:(NSDictionary*)arg;
- (void) deSelect:(NSDictionary*)arg;

- (void) downArrow;
- (void) leftArrow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
