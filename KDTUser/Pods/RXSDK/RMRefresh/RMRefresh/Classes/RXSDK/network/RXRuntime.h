//
//  RXRuntime.h
//  RMRefresh
//
//  Created by Ryan on 15/11/24.
//  Copyright © 2015年 RyanShen. All rights reserved.
//
#import "RXBaseCompoent.h"

NS_ASSUME_NONNULL_BEGIN
@interface RXRuntime : NSObject
singleton_interface(RXRuntime)
/** 操作系统 */
@property (nonatomic, copy, readonly) NSString *os;

/** 操作系统版本 */
@property (nonatomic, copy, readonly) NSString *osVersion;

/** 应用名 */
@property (nonatomic, copy, readonly) NSString *appName;

/** 应用版本 */
@property (nonatomic, copy, readonly) NSString *appVersion;

/** 设备ID */
@property (nonatomic, copy, readonly) NSString *udid;
@end
NS_ASSUME_NONNULL_END