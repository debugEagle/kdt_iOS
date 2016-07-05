//
//  XPCProxy.m
//  MACCLI
//
//  Created by wd on 15-5-27.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import "NSXPCProxy.h"
#import <objc/runtime.h>

@implementation NSXPCProxy

@synthesize proto = _proto;

- (id)initWithProto:(Protocol*)proto withPeer:(xpc_connection_t)peer {
    _proto = proto;
    _xpeer = peer;
    
    return self;
}

- (void)dealloc {
    xpc_connection_cancel(_xpeer);
    [super dealloc];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    struct objc_method_description methodDescriptions = protocol_getMethodDescription(_proto, sel ,1 , 1);   //获取函数描述
    assert(methodDescriptions.types);
    const char* type = methodDescriptions.types;
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:type];       //根据描述生成函数签名
    return sig;
}


//次函数跟句函数签名打包消息，可以参照 HPCoreSerivce - (void) handleEvent:(xpc_object_t)event 打包与解包。
//此时的invocation已经被填充好了参数，从中获取参数打包xpc message
- (void)forwardInvocation:(NSInvocation *)invocation {
    char* argtype = 0;
    int intarg = 0;
    char* chararg = 0;
    double doublearg = 0;
    
    char index[8];
    xpc_object_t msg = nil;
    NSMethodSignature* method = nil;
    const char* sel = nil;
    NSUInteger argcount = 0;
    id obj = nil;
    NSData* data = nil;
    NSError* error = nil;
    
    msg = xpc_dictionary_create(NULL,NULL,0);
    method = invocation.methodSignature;
    sel = sel_getName(invocation.selector);
    xpc_dictionary_set_string(msg, "sel", sel);
    
    argcount =  method.numberOfArguments;
    for (NSUInteger i = 2; i < argcount; i++) {
        sprintf(index,"%lu",(unsigned long)i);
        argtype = (char*)[method getArgumentTypeAtIndex:i];
        switch (*argtype) {
            case 'i':           //int
                 [invocation getArgument:&intarg atIndex:i];
                xpc_dictionary_set_int64(msg, index, intarg);
                 break;
            case '*':           //utf8 c strings
                [invocation getArgument:&chararg atIndex:i];
                xpc_dictionary_set_string(msg, index, chararg);
                break;
            case 'd':           //double
                [invocation getArgument:&doublearg atIndex:i];
                xpc_dictionary_set_double(msg, index, doublearg);
                break;
            case '@':           //id
                [invocation getArgument:&obj atIndex:i];
                data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONReadingAllowFragments error:&error];
                assert(!error);
                xpc_dictionary_set_data(msg, index, [data bytes], [data length]);
            default:
                break;
        }
    }
    xpc_connection_send_message(_xpeer, msg);
    xpc_release(msg);
}

@end
