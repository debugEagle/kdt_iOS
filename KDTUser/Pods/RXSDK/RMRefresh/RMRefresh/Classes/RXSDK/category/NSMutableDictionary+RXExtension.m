//
//  NSMutableDictionary+Extension.m
//  RXSDK
//
//  Created by Ryan on 15/11/17.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "NSMutableDictionary+RXExtension.h"

@implementation NSMutableDictionary (RXExtension)
/**
 *  处理urlQuery的参数转成可变字典
 *
 *  @param urlQuery
 *
 *  @return 可变字典
 */
+ (instancetype)rx_dealUrlParmasWithQuery:(NSString *)urlQuery;
{
    NSArray *strings = [urlQuery componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (NSString *string in strings)
    {
        NSArray *temp = [string componentsSeparatedByString:@"="];
        [dict setObject:[temp objectAtIndex:1] forKey:[temp objectAtIndex:0]];
    }
    return dict;
}

@end
