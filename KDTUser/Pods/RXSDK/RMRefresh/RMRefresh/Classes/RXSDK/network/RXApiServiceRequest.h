//
//  RXApiServiceRequest.h
//  RMRefresh
//
//  Created by Ryan on 15/11/24.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXSingleton.h"
NS_ASSUME_NONNULL_BEGIN
@interface RXApiServiceRequest : NSObject
/** 操作系统 */
@property (nonatomic, copy) NSString *os;
/** 操作系统版本 */
@property (nonatomic, copy) NSString *osVersion;
/** 应用名称 */
@property (nonatomic, copy) NSString *appName;
/** 应用版本 */
@property (nonatomic, copy) NSString *appVersion;
/** 设备UDID */
@property (nonatomic, copy) NSString *udid;
/** Session ID */
@property (nonatomic, copy) NSString *sessionId;
/** 请求服务名 */
@property (nonatomic, copy) NSString *serviceName;
/** 请求参数 */
@property (nonatomic, strong) NSDictionary *params;
@end
NS_ASSUME_NONNULL_END
