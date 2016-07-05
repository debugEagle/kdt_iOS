//
//  cell.m
//  ui
//
//  Created by wd on 15-6-21.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import "Utility.h"
#import "ScpViewCell.h"
#import "conf.h"

@implementation ScpViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.opaque = YES;
        
        /* icon */
        _icon = [[UIImageView alloc]init];
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_icon];
        
        /* set */
        //_set = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"set"]];
        _set = [[UIImageView alloc]init];
        _set.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_set];
        
        _many = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"many"]];
        _many.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_many];
        
        /* name */
        _name = [[UILabel alloc]init];
        _name.translatesAutoresizingMaskIntoConstraints = NO;
        _name.font = [UIFont systemFontOfSize:14];
        _name.textColor = [UIColor orangeColor];        //tableview reloadData 高亮颜色会消失
        [self.contentView addSubview:_name];
        
        /* descriptor */
        _descriptor = [[UILabel alloc]init];
        _descriptor.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptor.font = [UIFont systemFontOfSize:12];
        _descriptor.textColor = kUIColorFromRGB(0x808069);
        _descriptor.numberOfLines = 2;
        [_descriptor sizeToFit];
        _descriptor.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_descriptor];
        
        /* author */
        _author = [[UILabel alloc]init];
        _author.translatesAutoresizingMaskIntoConstraints = NO;
        _author.font = [UIFont systemFontOfSize:13];
        _author.textColor = [UIColor orangeColor];
        _author.numberOfLines = 1;
        [_author sizeToFit];
        _author.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_author];
        
        /* time */
        _time = [[UILabel alloc]init];
        _time.translatesAutoresizingMaskIntoConstraints = NO;
        _time.font = [UIFont systemFontOfSize:13];
        _time.textColor = [UIColor orangeColor];
        _time.numberOfLines = 1;
        [_time sizeToFit];
        _time.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_time];
        
        /* ver */
        _ver = [[UILabel alloc]init];
        _ver.translatesAutoresizingMaskIntoConstraints = NO;
        _ver.font = [UIFont systemFontOfSize:12];
        _ver.textColor = [UIColor blackColor];
        _ver.numberOfLines = 1;
        //_ver.layer.borderWidth = 1;
        //_ver.layer.borderColor = BTGobalRedColor.CGColor;

        [_ver sizeToFit];
        _ver.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_ver];
        
        /* line */
        _line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_line];
        
        [self updateConstraintsIfNeeded];
    }
    return self;
}
+ (CGFloat) heightWithContent:(NSDictionary*) doc {
    return 72.f;
}

- (void) renderWithContent:(NSDictionary*) doc {
    NSString* icon_path = [doc objectForKey:@"icon"];
    if (icon_path)
        self.icon.image = [UIImage imageWithContentsOfFile:icon_path];
    else
        self.icon.image = [UIImage imageNamed:@"default_scp_icon"];
    self.icon.layer.masksToBounds = icon_path ? YES : NO;
    self.icon.layer.cornerRadius = 30.0f;
    
    self.name.text = [doc objectForKey:@"name"];
    self.descriptor.text = [doc objectForKey:@"descriptor"];
    self.author.text = [doc objectForKey:@"author"];
    self.ver.text = [doc objectForKey:@"ver"];
    self.time.text = [doc objectForKey:@"time"];
    
    [[doc objectForKey:@"expand"] boolValue] ? [self downArrow] : [self leftArrow];
    [[doc objectForKey:@"select"] boolValue] ? [self setSelect:doc] : [self deSelect:doc];
    
    [self setNeedsUpdateConstraints];
}


- (void) dealloc{
    [_icon release];
    [_name release];
    [_set release];
    [_many release];
    [_line release];
    [_descriptor release];
    [_author release];
    [_ver release];
    [super dealloc];
}


- (void) downArrow{
    //WDLog(".");
    _many.layer.transform = CATransform3DMakeRotation(0, 0, 0, 0);
    //_many.transform =  CGAffineTransformMakeRotation(-M_PI_2);
    
    [CATransaction begin];
    
    CABasicAnimation *FlipAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    FlipAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    FlipAnimation.toValue= [NSNumber numberWithFloat:-M_PI_2];
    FlipAnimation.duration = 0.2;
    FlipAnimation.fillMode = kCAFillModeForwards;
    FlipAnimation.removedOnCompletion = NO;
    [_many.layer addAnimation:FlipAnimation forKey:@"flip"];
    
    [CATransaction commit];
}

- (void) leftArrow{
    //WDLog(".");
    //_many.transform =  CGAffineTransformMakeRotation(M_PI_2);
    _many.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, -1);
    
    [CATransaction begin];
    
    CABasicAnimation *FlipAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    FlipAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    FlipAnimation.toValue= [NSNumber numberWithFloat:0];
    FlipAnimation.duration = 0.2;
    FlipAnimation.fillMode = kCAFillModeForwards;
    FlipAnimation.removedOnCompletion = NO;
    [_many.layer addAnimation:FlipAnimation forKey:@"flip"];
    
    [CATransaction commit];
}

- (void) setSelect:(NSDictionary*)arg {
    
    _icon.layer.borderWidth = 2.0;
    _icon.layer.borderColor = [UIColor redColor].CGColor;
    
    NSString* icon_path = [arg objectForKey:@"icon"];
    if (!icon_path) {
        self.icon.image = [UIImage imageNamed:@"default_scp_icon2"];
    }
    
}

- (void) deSelect:(NSDictionary*)arg {
    _icon.layer.borderWidth = 1.0;
    _icon.layer.borderColor = [UIColor whiteColor].CGColor;
    NSString* icon_path = [arg objectForKey:@"icon"];
    if (!icon_path) {
        self.icon.image = [UIImage imageNamed:@"default_scp_icon"];
    }
}

- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
}

- (void)updateConstraints{
    if (self.saveConstraints && self.saveConstraints.count) {
        [self.contentView removeConstraints:self.saveConstraints];
    }
    
    UIView* i = self.icon;
    UIView* n = self.name;
    UIView* d = self.descriptor;
    UIView* m = self.many;
    UIView* l = self.line;
    UIView* a = self.author;
    UIView* t = self.time;
    UIView* v = self.ver;
    
    NSArray* constraints = @[
                             @"H:|-10-[i(==60)]-10-[n]-10-[v(<=50)]",
                             @"H:[i]-10-[d]-20-|",
                             @"H:[m]-10-|",
                             @"V:|-5-[m]",
                             @"V:|-5-[i(==60)]",
                             @"V:|-3-[n]-3-[d]",
                             @"V:|-5-[v]",
                             @"H:|-5-[l]|",
                             @"V:[l(==1)]|",
                             @"H:[a]-[t]-(8)-|",
                             @"V:[a(<=50)]-(3)-|",
                             @"V:[t(<=50)]-(3)-|",
                             ];
    
    NSMutableArray* saveConstraints = [NSMutableArray array];
    
    for (NSString* fmt in constraints)
    {
        NSArray* constraint = [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(i,n,d,m,l,a,v,t)];
        [self.contentView addConstraints: constraint];
        [saveConstraints addObjectsFromArray:constraint];
    }
    self.saveConstraints = saveConstraints;

    [super updateConstraints];
}



@end
