//
//  RXApiServiceResponse.h
//  RMRefresh
//
//  Created by Ryan on 15/11/24.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXSingleton.h"
typedef NS_ENUM(NSInteger , RXApiServiceResponseStatus)
{
    // 请求成功
    RXApiServiceResponseStatusSuccess = 0,
    // 请求失败或有误
    RXApiServiceResponseStatusFailure = 1
};

@interface RXApiServiceResponse : NSObject
/** 应答状态 */
@property (nonatomic, assign) RXApiServiceResponseStatus status;
/** 错误消息，如无错，则为nil */
@property (nonatomic, copy) NSString *errorMessage;
/** 应答内容 */
@property (nonatomic, strong) NSDictionary * content;

@end


