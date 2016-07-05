//
//  NSBundle+Extension.m
//  EPIMApp
//
//  Created by 沈文涛 on 15/10/24.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "NSBundle+RXExtension.h"

@implementation NSBundle (RXExtension)
/**
 *  加载从Bundle加载Xib
 *
 *  @param xibName xib的名字
 *
 *  @return xib
 */
+ (id)rx_loadXibNameWith:(NSString *)xibName
{
    return [[[NSBundle mainBundle] loadNibNamed:xibName
                                          owner:nil
                                        options:nil] lastObject];
}

@end
