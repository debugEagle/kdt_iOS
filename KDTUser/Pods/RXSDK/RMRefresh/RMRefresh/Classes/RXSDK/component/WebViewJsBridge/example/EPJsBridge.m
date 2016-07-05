//
//  EPJsBridge.m
//  EPIMApp
//
//  Created by Ryan on 15/10/29.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "EPJsBridge.h"

@implementation EPJsBridge

/**
 *  js调用OC的实例方法,无参数
 */
- (void)exampleMethod{
    NSLog(@"exampleMethod");
}

/**
 *  js调用OC的实例方法,有参数
 */
- (void)exampleMethodWithParmas:(NSDictionary *)parmas{
    NSLog(@"exampleMethodWithParmas --- %@",parmas);
}


@end
