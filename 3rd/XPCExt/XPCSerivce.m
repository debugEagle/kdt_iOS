//
//  HPSerivce.m
//  KDTService
//
//  Created by wd on 16-3-27.
//
//

#import "XPCSerivce.h"


@implementation XPCSerivce {
    NSMutableDictionary*    ENV;
}


-(id) init {
    self = [super init];
    if (self) {
        ENV = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc {
    [ENV release];
    [super dealloc];
}

-(NSDictionary*) ENV {
    return ENV;
}

- (void) handleEvent:(xpc_object_t)event {
    char* argtype = 0;
    int64_t intarg = 0;
    char* chararg = 0;
    double doublearg = 0;
    id json = nil;
    NSData* data = nil;
    const void* bytes = 0;
    size_t length = 0;
    NSError* error = nil;
    
    char index[4];
    const char* sel = xpc_dictionary_get_string(event, "sel");      //获得sel
    
    NSMethodSignature* method = [self methodSignatureForSelector:sel_registerName(sel)];    //根据sel得到调用函数签名
    if (!method) {
        WDLog("sel:%s is nil",sel);
    }
    assert(method);
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:method];         //创建 调用invocation，下面需要填充invocation
    assert(invocation);
    [invocation setSelector:sel_registerName(sel)];     //设置sel
    
    NSUInteger argCount =  method.numberOfArguments;
    for (NSUInteger i = 2; i< argCount; i++) {
        sprintf(index,"%lu",(unsigned long)i);
        argtype = (char*)[method getArgumentTypeAtIndex:i];     //获取函数签名中的参数类型
        switch (*argtype) {
            case 'i':           //int
                intarg = xpc_dictionary_get_int64(event, index);
                [invocation setArgument:&intarg atIndex:i];
                break;
            case '*':           //utf8 c strings
                chararg = (void*)xpc_dictionary_get_string(event, index);
                [invocation setArgument:&chararg atIndex:i];
                break;
            case 'd':           //double
                doublearg = xpc_dictionary_get_double(event, index);
                [invocation setArgument:&doublearg atIndex:i];
                break;
            case '@':           //id
                length = 0;
                bytes = xpc_dictionary_get_data(event, index, &length);
                data = [NSData dataWithBytes:bytes length:length];
                json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                assert(!error);
                [invocation setArgument:&json atIndex:i];
                break;
                
            default:
                WDLog("未知的参数类型");
                break;
        }
    }
    [invocation invokeWithTarget:self];     //调用
}

-(id) getEnv:(id) key {
    return [ENV objectForKey:key];
}

-(void) setEnv:(id) value forKey:(id) key {
    if (value)
        [ENV setObject:value forKey:key];
    else
        [ENV removeObjectForKey:key];
}

@end
