//
//  CYLPlusButton.m
//  CYLCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "BTPlusButton.h"
#import "BTTabBarController.h"

UIButton<CYLPlusButtonSubclassing> *CYLExternPushlishButton = nil;
@interface BTPlusButton ()<UIActionSheetDelegate>

@end

@implementation BTPlusButton

#pragma mark -
#pragma mark - Private Methods

+ (void)registerSubclass {
    if ([self conformsToProtocol:@protocol(CYLPlusButtonSubclassing)]) {
        Class<CYLPlusButtonSubclassing> class = self;
        CYLExternPushlishButton = [class plusButton];
    }
}

@end
