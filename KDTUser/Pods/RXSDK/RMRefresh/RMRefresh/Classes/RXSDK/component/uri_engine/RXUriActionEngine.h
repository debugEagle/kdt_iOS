//
// Created by K on 6/11/15.
// Copyright (c) 2015 iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableDictionary+RXExtension.h"
#import "RXSingleton.h"

@protocol EPUriActionHandlerProtocol <NSObject>

/** 所支持的Scheme */
- (NSString *)supportedScheme;

/** 所支持的Host */
- (NSString *)supportedHost;

/** 处理URI */
- (BOOL)handleUri:(NSURL *)uri;

@end

@interface RXUriActionEngine : NSObject

singleton_interface(RXUriActionEngine)

/** 注册处理器 */
- (void)register:(id <EPUriActionHandlerProtocol>)handler;

/** 处理URI */
- (BOOL)handle:(NSURL *)uri;

@end