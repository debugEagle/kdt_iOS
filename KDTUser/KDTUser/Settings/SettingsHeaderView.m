//
//  SettingsHeaderView.m
//  KDTUser
//
//  Created by wd on 16/5/9.
//  Copyright © 2016年 wd. All rights reserved.
//

#import "SettingsHeaderView.h"
#import "HPLocalClient.h"
#import "NetStub.h"
#import "conf.h"
#import "Utility.h"

@implementation SettingsHeaderView

-(instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = BTGobalRedColor;
        //self.clipsToBounds = YES;
        [self setup];
    }
    return self;
}


-(void) updateLicence:(NSDictionary*) licence {
    NSDictionary* payload = [licence objectForKey:@"payload"];
    NSNumber* valid = [payload objectForKey:@"valid"];
    if ([valid isEqualToNumber:@1]) {
        self.button.text = @"已授权";
        //self.licenced.image = [UIImage imageNamed:@"Settings-licence-true"];
    } else {
        self.button.text = @"点击授权";
        //self.licenced.image = [UIImage imageNamed:@"Settings-licence-false"];
    }
}


-(void) setup {
    /* 非autolayer 布局的背景 */
    _background = [[UIImageView alloc] init];
    _background.image = [UIImage imageNamed:@"Settings-bg"];
    //_background.translatesAutoresizingMaskIntoConstraints = NO;
    _background.frame = self.bounds;
    [self addSubview:_background];
    
    _licenced = [[UIImageView alloc] init];
    //_licenced.image = [UIImage imageNamed:@"Settings-licence-false"];
    _licenced.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_licenced];
    
    _title = [[UILabel alloc] init];
    _title.backgroundColor = [UIColor clearColor];
    _title.font = [UIFont systemFontOfSize:14];
    _title.translatesAutoresizingMaskIntoConstraints = NO;
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.text = @"脚本在手 轻松遨游!";
    [self addSubview:_title];
    
    _widget = [[UIImageView alloc] init];
    _widget.image = [UIImage imageNamed:@"Settings-widget"];
    _widget.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_widget];
    
    _button = [[UILabel alloc] init];
    _button.layer.masksToBounds = YES;
    _button.font = [UIFont systemFontOfSize:14];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.layer.cornerRadius = 5.0f;
    _button.backgroundColor = BTGobalRedColor;
    //_button.alpha = 0.5f;
    _button.layer.borderWidth = 1;
    _button.layer.borderColor = [BTGobalRedColor CGColor];
    _button.text = @"点击授权";
    _button.textColor = [UIColor whiteColor];
    _button.textAlignment = NSTextAlignmentCenter;
    //_button.image = [UIImage imageNamed:@"Settings-button"];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.userInteractionEnabled = YES;
    [self addSubview:_button];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_button addGestureRecognizer:tap];
    
    [self setNeedsUpdateConstraints];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    HPLocalClient*  hp = [HPLocalClient sharedInstance];
    NSDictionary* licence = [hp getEnv:@"licence"];
    if (!licence) return;
    NSString* uuid = [licence objectForKey:@"devInfo"];
    if (buttonIndex == 0) {
        UITextField* textField = [alertView textFieldAtIndex:0];
        [textField resignFirstResponder];
    }
    if (buttonIndex == 1) {
        UITextField* textField = [alertView textFieldAtIndex:0];
        [textField resignFirstResponder];
        NSString* serial = textField.text;
        NSLog(@"%@:%@", uuid, serial);
        NSString* url = [NSString stringWithFormat:
                         @"http://wx.jomton.com/applogin.php?action=useSerial&uuid=%@&serial=%@",
                         uuid, serial];
        [NetStub Get:[NSURL URLWithString:url]
             timeOut:5
           onSuccess:^(NSError *error, id json){
               [(id)hp.proxy licence];
               NSString* msg = @"未知错误";
               if ([json isKindOfClass: [NSNumber class]]) {
                   NSDictionary* msgs = @{@"-3": @"还在授权期内",
                                          @"-2": @"激活码无效",
                                          @"-1": @"激活码为空",
                                          @"0" : @"激活失败",
                                          @"1" : @"激活成功"};
                   msg = [msgs objectForKey:[json stringValue]];
               }
               UIAlertView* alert = [[UIAlertView alloc] initWithTitle:msg
                                                               message:nil
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
               [alert show];
           }
           onFailure:^(NSError *error){
               NSLog(@"%@",error);
           }];
    }
}


-(void) tap:(id)sender {
    HPLocalClient*  hp = [HPLocalClient sharedInstance];
    NSDictionary* licence = [hp getEnv:@"licence"];
    if (!licence) return;
    NSDictionary* payload = [licence objectForKey:@"payload"];
    NSNumber* valid = [payload objectForKey:@"valid"];
    WDLog("%@", valid);
    if ([valid isEqualToNumber:@1]) return;
    
    UIAlertView* licenceInput = [[UIAlertView alloc] initWithTitle:@"请输入授权码"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"验证", nil];
    [licenceInput setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [licenceInput show];
}


- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
}


- (void) updateConstraints {
    [self removeConstraints:self.constraints];
    UIView* widget = self.widget;
    UIView* licenced = self.licenced;
    UIView* title = self.title;
    UIView* button = self.button;
    
    
    CGFloat height = self.frame.size.height * 0.2;
    CGFloat width = (self.frame.size.width - 80) / 2;
    
    NSDictionary *metrics = @{@"height":NS_Float(height),@"width":NS_Float(width)};
    
    NSArray* constraints = @[@"H:[widget(100)]",
                             @"H:[licenced(35)]-30-|",
                             @"V:|-30-[licenced(70)]",
                             @"V:|-height-[widget(100)]-5-[title(15)]-10-[button(30)]-(>=0)-|",
                             @"H:|-width-[button(80)]-width-|"
                             ];
    
    for (NSString* fmt in constraints)
    {
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:metrics
                                                                        views:
                               NSDictionaryOfVariableBindings(widget,licenced, title,button)]];
    }
    [super updateConstraints];
}


@end
