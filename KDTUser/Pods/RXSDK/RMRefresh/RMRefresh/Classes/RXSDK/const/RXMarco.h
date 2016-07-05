//
//  RXMarco.h
//  RXSDK
//
//  Created by Ryan on 15/11/17.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#ifndef RXMarco_h
#define RXMarco_h
// 设备机型
#define rx_iPhone4  [UIScreen mainScreen].bounds.size.height==480 ? YES : NO
#define rx_iPhone5  [UIScreen mainScreen].bounds.size.height==568 ? YES : NO
#define rx_iPhone6  [UIScreen mainScreen].bounds.size.width ==375 ? YES : NO
#define rx_iPhone6P [UIScreen mainScreen].bounds.size.height==736 ? YES : NO
// 设备系统
#define rx_iOS7 [[UIDevice currentDevice].systemVersion doubleValue] >= 7.0
#define rx_iOS8 [[UIDevice currentDevice].systemVersion doubleValue] >= 8.0
#define rx_iOS9 [[UIDevice currentDevice].systemVersion doubleValue] >= 9.0
// 设备屏幕尺寸
#define rx_kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define rx_kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
// 一像素的宽度
#define rx_SINGLE_LINE_WIDTH  (1.0f / [[UIScreen mainScreen] scale])
// 调试输出日志
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#endif /* RXMarco_h */
