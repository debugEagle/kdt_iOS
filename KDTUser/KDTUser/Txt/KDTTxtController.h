//
//  BTWebViewVC.h
//  BanTang
//
//  Created by 沈文涛 on 15/11/29.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDTTxtController : UIViewController

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL isModalStyle;

+(instancetype) sharedInstance;

@end
