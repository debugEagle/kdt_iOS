//
//  XPCProxy.h
//  xpc消息代理类定义
//
//  Created by wd on 15-5-27.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>


//该类的用处是作为消息转发代理，Protocol为对方的协议。

@interface NSXPCProxy : NSProxy{
@private
    Protocol* _proto;
    xpc_connection_t _xpeer;
}
@property (nonatomic,readonly) Protocol* proto;

- (id)initWithProto:(Protocol*)proto withPeer:(xpc_connection_t)peer;

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel;     //重载methodSignatureForSelector
- (void)forwardInvocation:(NSInvocation *)invocation;           //重载forwardInvocation

@end
