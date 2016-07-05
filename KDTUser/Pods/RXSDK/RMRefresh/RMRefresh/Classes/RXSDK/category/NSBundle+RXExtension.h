//
//  NSBundle+Extension.h
//  EPIMApp
//
//  Created by 沈文涛 on 15/10/24.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import <UIKit/UIkit.h>

@interface NSBundle (RXExtension)
/**
 *  加载从Bundle加载Xib
 *
 *  @param xibName xib的名字
 *
 *  @return xib
 */
+ (id)rx_loadXibNameWith:(NSString *)xibName;

@end
