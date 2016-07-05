//
//  BTWebViewVC.h
//  BanTang
//
//  Created by 沈文涛 on 15/11/29.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDTWebController : UIViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isModalStyle;

+(instancetype) sharedInstance;

@end
