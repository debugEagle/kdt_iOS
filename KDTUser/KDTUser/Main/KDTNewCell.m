//
//  KDTNewCell.m
//  KDTUser
//
//  Created by wd on 16/5/3.
//  Copyright © 2016年 wd. All rights reserved.
//

#import "KDTNewCell.h"
#import "conf.h"
#import "UIImageView+YYWebImage.h"

@implementation KDTNewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BTBackgroundColor;
        self.opaque = YES;
        [self setup];
    }
    return self;
}


- (void) setup {
    _container = [[UIView alloc] init];
    _container.layer.masksToBounds = YES;
    _container.translatesAutoresizingMaskIntoConstraints = NO;
    _container.layer.cornerRadius = 5.0f;
    _container.backgroundColor = [UIColor whiteColor];
    _container.layer.borderWidth = 1;
    _container.layer.borderColor = [BTGobalRedColor CGColor];
    [self.contentView addSubview:_container];
    
    _game = [[UILabel alloc]init];
    _game.translatesAutoresizingMaskIntoConstraints = NO;
    _game.backgroundColor = kUIColorFromRGB(0xec5252);
    _game.layer.masksToBounds = YES;
    _game.layer.cornerRadius = 3.0f;
    _game.font = [UIFont systemFontOfSize:16];
    _game.textColor = [UIColor whiteColor];
    [_container addSubview:_game];
    
    _type = [UIView new];
    [_container addSubview:_type];
    
    _time = [[UILabel alloc]init];
    _time.translatesAutoresizingMaskIntoConstraints = NO;
    _time.font = [UIFont systemFontOfSize:14];
    _time.textColor = [UIColor blackColor];
    [_container addSubview:_time];
    
    _title = [[UILabel alloc]init];
    _title.translatesAutoresizingMaskIntoConstraints = NO;
    _title.font = [UIFont systemFontOfSize:16];
    _title.numberOfLines = 0;
    _title.textColor = [UIColor blackColor];
    [_container addSubview:_title];
    
    _author = [[UILabel alloc]init];
    _author.translatesAutoresizingMaskIntoConstraints = NO;
    _author.font = [UIFont systemFontOfSize:14];
    _author.textColor = [UIColor orangeColor];
    [_container addSubview:_author];
    
    _describe = [[UILabel alloc]init];
    _describe.translatesAutoresizingMaskIntoConstraints = NO;
    _describe.font = [UIFont systemFontOfSize:14];
    _describe.textColor = kUIColorFromRGB(0x808069);
    _describe.numberOfLines = 0;
    [_container addSubview:_describe];
    
    _image1 = [[UIImageView alloc] init];
    _image1.translatesAutoresizingMaskIntoConstraints = NO;
    [_container addSubview:_image1];
    
    _image2 = [[UIImageView alloc] init];
    _image2.translatesAutoresizingMaskIntoConstraints = NO;
    [_container addSubview:_image2];
    
    _image3 = [[UIImageView alloc] init];
    _image3.translatesAutoresizingMaskIntoConstraints = NO;
    [_container addSubview:_image3];
}


- (void) renderWithContent:(NSDictionary*) doc {
    self.doc = doc;
    _game.text = [doc objectForKey:@"game"];
    _author.text = [doc objectForKey:@"author"];
    _time.text = [doc objectForKey:@"time"];
    _title.text = [doc objectForKey:@"title"];
    _describe.text = [doc objectForKey:@"describe"];
    
    _image1.hidden = YES;
    _image2.hidden = YES;
    _image3.hidden = YES;
    
    NSString* urlImage1 = [doc objectForKey:@"image1"];
    if (urlImage1) {
        [_image1 yy_setImageWithURL:[NSURL URLWithString:urlImage1]
                            placeholder:[UIImage imageNamed:@"default_image"]
                                options:  YYWebImageOptionSetImageWithFadeAnimation
                                        | YYWebImageOptionProgressiveBlur
                                        | YYWebImageOptionShowNetworkActivity
                             completion:nil];
        _image1.hidden = NO;
    }
    NSString* urlImage2 = [doc objectForKey:@"image2"];
    if (urlImage2) {
        [_image2 yy_setImageWithURL:[NSURL URLWithString:urlImage2]
                            placeholder:[UIImage imageNamed:@"default_image"]
                                options:  YYWebImageOptionSetImageWithFadeAnimation
                                        | YYWebImageOptionProgressiveBlur
                                        | YYWebImageOptionShowNetworkActivity
                             completion:nil];
        _image2.hidden = NO;
    }
    
    NSString* urlImage3 = [doc objectForKey:@"image3"];
    if (urlImage3) {
        [_image3 yy_setImageWithURL:[NSURL URLWithString:urlImage3]
                            placeholder:[UIImage imageNamed:@"default_image"]
                                options:  YYWebImageOptionSetImageWithFadeAnimation
                                        | YYWebImageOptionProgressiveBlur
                                        | YYWebImageOptionShowNetworkActivity
                             completion:nil];
        _image3.hidden = NO;
    }
    [self setNeedsUpdateConstraints];
}


+ (CGFloat) heightWithContent:(NSDictionary*) doc {
    id image1 = [doc objectForKey:@"image1"];
    id image2 = [doc objectForKey:@"image2"];
    id image3 = [doc objectForKey:@"image3"];
    if (image1 && image2 && image3) {
        return 180.f;
    } else if (image1) {
        return 168.f;
    } else
        return 118.f;
}

- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
}

- (void) updateConstraints {
    if (self.saveConstraints && self.saveConstraints.count) {
        [self.contentView removeConstraints:self.saveConstraints];
    }
    UIView* container = self.container;
    UIView* game = self.game;
    UIView* type = self.type;
    UIView* author = self.author;
    UIView* time = self.time;
    UIView* title = self.title;
    UIView* describe = self.describe;
    
    NSArray* baseConstraints = @[
                                 @"H:|[container]|",
                                 @"V:|[container]-(8)-|",
                                 @"H:|-(8)-[game]-(8)-[title]-(>=5)-|",
                                 @"H:[author]-[time]-(8)-|",
                                 @"V:|-(8)-[game]",
                                 @"V:|-(8)-[title]",
                                 @"V:[author]-(5)-|",
                                 @"V:[time]-(5)-|"];
    
    NSDictionary* baseViews = NSDictionaryOfVariableBindings(container,game,type,author,time,title,describe);
    
    NSMutableArray* constraints = [NSMutableArray arrayWithArray:baseConstraints];
    NSMutableDictionary* views = [NSMutableDictionary dictionaryWithDictionary:baseViews];
    
    id image1 = [self.doc objectForKey:@"image1"];
    id image2 = [self.doc objectForKey:@"image2"];
    id image3 = [self.doc objectForKey:@"image3"];
    
    if (image1 && image2 && image3) {
        [constraints addObject:@"H:|-(10)-[image1]-[image2(image1)]-[image3(image1)]-(10)-|"];
        [constraints addObject:@"V:[game]-(8)-[image1(70)]"];
        [constraints addObject:@"V:[game]-(8)-[image2(70)]"];
        [constraints addObject:@"V:[game]-(8)-[image3(70)]"];
        [constraints addObject:@"H:|-(8)-[describe]-(8)-|"];
        [constraints addObject:@"V:[image1]-(8)-[describe]"];
        [views setObject:_image1 forKey:@"image1"];
        [views setObject:_image2 forKey:@"image2"];
        [views setObject:_image3 forKey:@"image3"];
        _describe.numberOfLines = 2;
    } else if (image1) {
        [constraints addObject:@"H:|-(8)-[image1(150)]-(8)-[describe]-(5)-|"];
        [constraints addObject:@"V:[game]-(8)-[image1(95)]"];
        [constraints addObject:@"V:[game]-(5)-[describe]"];
        [views setObject:_image1 forKey:@"image1"];
        _describe.numberOfLines = 6;
    } else {
        [constraints addObject:@"H:|-(8)-[describe]-(8)-|"];
        [constraints addObject:@"V:[game]-(5)-[describe]"];
        _describe.numberOfLines = 3;
    }
    
    NSMutableArray* saveConstraints = [NSMutableArray array];
    
    for (NSString* fmt in constraints)
    {
        NSArray* constraint = [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
        [self.contentView addConstraints: constraint];
        [saveConstraints addObjectsFromArray:constraint];
    }
    self.saveConstraints = saveConstraints;
    [super updateConstraints];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
