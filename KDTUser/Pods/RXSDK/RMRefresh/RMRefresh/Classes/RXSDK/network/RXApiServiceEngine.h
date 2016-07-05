//
//  RXApiServiceEngine.h
//  RMRefresh
//
//  Created by Ryan on 15/11/24.
//  Copyright © 2015年 RyanShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXBaseCompoent.h"
#import "RXSingleton.h"
typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2
};

typedef void(^CompletionHandler)(id jsonData,NSError *error);
typedef void(^SuccessHandler)(NSDictionary *jsonData);
typedef void(^FailureHandler)(NSError *error);

@interface RXApiServiceEngine : RXBaseCompoent
singleton_interface(RXApiServiceEngine)
/**
 *  发送一个请求
 *
 *  @param type    请求类型,POST or GET
 *  @param url     路径
 *  @param params  参数
 *  @param handler 完成的处理
 */
+ (void)requestWithType:(RequestMethodType)type
                    url:(NSString *)url
             parameters:(NSDictionary *)parameters
      completionHanlder:(CompletionHandler)handler;
/**
 *   发送一个拼接httpbody类型的POST请求,
 *
 *  @param servies        服务名
 *  @param parameters     参数
 *  @param successHandler 成功回调
 *  @param failureHanler  失败回调
 */
- (void)requestService:(NSString *)servies
            parameters:(NSDictionary *)parameters
             onSuccess:(SuccessHandler)successHandler
             onFailure:(FailureHandler)failureHanler;
/**
 *  初始化
 *
 *  @param baseUrl   URL
 *  @param secretKey 秘钥
 */
- (instancetype)initWithBaseUrl:(NSString *)baseUrl
                      secretKey:(NSString *)secretKey;

/**
 *  取消所有任务
 */
- (void)cancelAllTask;

@end
