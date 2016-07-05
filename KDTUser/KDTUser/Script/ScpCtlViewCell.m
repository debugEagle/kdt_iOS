//
//  AttachedCell.m
//  NT
//
//  Created by Kohn on 14-5-27.
//  Copyright (c) 2014年 Pem. All rights reserved.
//

#import "Utility.h"
#import "ScpCtlViewCell.h"
#import "conf.h"

#define USE_COLOR [UIColor colorWithRed:0.0/255 green:201.0/255 blue:87.0/255 alpha:100.0]

#define MAN_COLOR [UIColor colorWithRed:30.0/255 green:144.0/255 blue:255.0/255 alpha:100.0]

#define DEL_COLOR BTGobalRedColor

#define SET_COLOR [UIColor colorWithRed:255.0/255 green:153.0/255 blue:18.0/255 alpha:100.0]

@implementation ScpCtlViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.opaque = YES;
        
        UILabel* txt = nil;
        UITapGestureRecognizer* tap = nil;
        
        /* sel */
        _use = [[UIView alloc]init];
        _use.translatesAutoresizingMaskIntoConstraints = NO;
        txt = [[UILabel alloc]init];
        txt.translatesAutoresizingMaskIntoConstraints = NO;
        txt.text = @"启用";
        txt.textColor = [UIColor whiteColor];
        txt.font = [UIFont systemFontOfSize:16];
        [_use addSubview:txt];
        ALIGN_CENTER(txt);
        _use.tag = 0;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_use addGestureRecognizer:tap];
        [tap release];
        _use.backgroundColor = USE_COLOR;
        [self.contentView addSubview:_use];
        _use.layer.borderColor = [[UIColor whiteColor] CGColor];
        _use.layer.borderWidth = 1;
        //CENTER_V(_use);
        
        /* man */
        _man = [[UIView alloc]init];
        _man.translatesAutoresizingMaskIntoConstraints = NO;
        txt = [[UILabel alloc]init];
        txt.translatesAutoresizingMaskIntoConstraints = NO;
        txt.text = @"说明";
        txt.font = [UIFont systemFontOfSize:16];
        txt.textColor = [UIColor whiteColor];
        [_man addSubview:txt];
        ALIGN_CENTER(txt);
        _man.tag = 1;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_man addGestureRecognizer:tap];
        [tap release];
        _man.backgroundColor = MAN_COLOR;
        [self.contentView addSubview:_man];
        _man.layer.borderColor = [[UIColor whiteColor] CGColor];
        _man.layer.borderWidth = 1;
        //CENTER_V(_man);
        
        /* set */
        _set = [[UIView alloc]init];
        _set.translatesAutoresizingMaskIntoConstraints = NO;
        txt = [[UILabel alloc]init];
        txt.translatesAutoresizingMaskIntoConstraints = NO;
        txt.text = @"删除";
        txt.font = [UIFont systemFontOfSize:16];
        txt.textColor = [UIColor whiteColor];
        [_set addSubview:txt];
        ALIGN_CENTER(txt);
        _set.tag = 2;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_set addGestureRecognizer:tap];
        [tap release];
        _set.backgroundColor = DEL_COLOR;
        [self.contentView addSubview:_set];
        _set.layer.borderColor = [[UIColor whiteColor] CGColor];
        _set.layer.borderWidth = 1;
        //CENTER_V(_set);
        
        /* del */
        _del = [[UIView alloc]init];
        _del.translatesAutoresizingMaskIntoConstraints = NO;
        txt = [[UILabel alloc]init];
        txt.translatesAutoresizingMaskIntoConstraints = NO;
        txt.text = @"设置";
        txt.font = [UIFont systemFontOfSize:16];
        txt.textColor = [UIColor whiteColor];
        [_del addSubview:txt];
        ALIGN_CENTER(txt);
        _del.tag = 3;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_del addGestureRecognizer:tap];
        [tap release];
        _del.backgroundColor = SET_COLOR;
        [self.contentView addSubview:_del];
        _del.layer.borderColor = [[UIColor whiteColor] CGColor];
        _del.layer.borderWidth = 1;
        //CENTER_V(_del);
        
        /* line */
        _line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_line];
        
        [self updateConstraintsIfNeeded];
    }
    return self;
}

//+ (BOOL) requiresConstraintBasedLayout
//{
//    return NO;
//}


-(void) tap:(id)sender{
    UITapGestureRecognizer* tap = sender;
    __block UIView* tap_view = [tap.view retain];
    __block ScpCtlViewCell* cell = [self retain];
    
    [UIView animateWithDuration:0.05 animations:^{
        tap_view.backgroundColor = [UIColor darkGrayColor];
    } completion:^(BOOL finished) {
        switch (tap_view.tag) {
            case 0:
                tap_view.backgroundColor = USE_COLOR;
                break;
            case 1:
                tap_view.backgroundColor = MAN_COLOR;
                break;
            case 2:
                tap_view.backgroundColor = DEL_COLOR;
                break;
            case 3:
                tap_view.backgroundColor = SET_COLOR;
                break;
        }
        [(id)cell.delegate handleEvent:tap_view.tag];
        [tap_view release];
        [cell release];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void) dealloc{
    NSLog(@"dealloc");
    [_use release];
    [_man release];
    [_set release];
    [_del release];
    [super dealloc];
}

- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    UIView* u = self.use;
    UIView* m = self.man;
    UIView* s = self.set;
    UIView* d = self.del;
    UIView* l = self.line;
    
    NSArray* constraints = @[
                      @"H:|[u(>=0)]-(-1)-[m(u)]-(-1)-[s(u)]-(-1)-[d(u)]|",
                      @"V:|[u]|",
                      @"V:|[m(u)]|",
                      @"V:|[s(u)]|",
                      @"V:|[d(u)]|",
                      @"H:|[l]|",
                      @"V:[l(==1)]|",
                      ];

    for (NSString* fmt in constraints)
    {
        [self.contentView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:NSDictionaryOfVariableBindings(u,m,s,d,l)]];
    }
    [super updateConstraints];
}


@end
