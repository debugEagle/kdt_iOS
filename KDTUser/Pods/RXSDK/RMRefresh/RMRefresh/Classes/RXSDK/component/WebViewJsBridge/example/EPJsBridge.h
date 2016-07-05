//
//  EPJsBridge.h
//  EPIMApp
//
//  Created by Ryan on 15/10/29.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "WebViewJsBridge.h"

/**
 *  如果要使用JS与OC之间的调用，需要修改WebViewJsBridge.h
 *  的kBridgeName和WebViewJsBridge.js的bridge参数,
 *  与html里面的bridge要相同.
 */
@interface EPJsBridge : WebViewJsBridge

/**
 *  js调用OC的实例方法,无参数
 */
- (void)exampleMethod;

/**
 *  js调用OC的实例方法,有参数
 */
- (void)exampleMethodWithParmas:(NSDictionary *)parmas;

@end
