//
//  RXRuntime.m
//  RMRefresh
//
//  Created by Ryan on 15/11/24.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import "RXRuntime.h"
#import <UIKit/UIKit.h>
#import "OpenUDID.h"
@implementation RXRuntime
singleton_implementation(RXRuntime)
- (id)init
{
    self = [super init];
    if (self)
    {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSDictionary *info = mainBundle.infoDictionary;
        _appName = info[@"CFBundleName"];
        _appVersion = info[@"CFBundleShortVersionString"];
        
        _os = [[UIDevice currentDevice] systemName];
        _osVersion = [[UIDevice currentDevice] systemVersion];
        _udid = [OpenUDID value];
    }
    return self;
}

@end
