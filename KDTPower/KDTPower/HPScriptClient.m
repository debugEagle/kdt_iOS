//
//  HPScriptClient.m
//  KDTPower
//
//  Created by wd on 16-3-28.
//
//

#import "HPScriptClient.h"
#import "NSLuaCore.h"
#include "conf.h"

@implementation HPScriptClient

+(id) sharedInstance {
    static HPScriptClient* _serivce;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _serivce = [[HPScriptClient alloc] init];
        
    });
    return _serivce;
}


-(id) init {
    self = [super init];
    if (self) {
        xpc_connection_t connection = xpc_connection_create_mach_service(HPScriptServiceName,
                                                                         dispatch_get_main_queue(),
                                                                         0);
        if (!connection) {
            WDLog("Failed to create service.");
            exit(1);
        }
        NSXPCProxy* proxy = [[[NSXPCProxy alloc] initWithProto:@protocol(ScriptServiceProtocol)
                                                      withPeer:connection] autorelease];
        self.proxy = proxy;
        self.peer = connection;
        NSString* select = [[NSDictionary dictionaryWithContentsOfFile:KDT_SETTINGS_PATH] objectForKey:@"select"];
        self.path = nil;
        if (![select isEqualToString:@""])
            self.path = [NSString stringWithFormat:@"%@/script/%@", KDT_DOC_PATH, select];
        __block id _self = self;
        xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
            xpc_type_t xtype = xpc_get_type(event);
            if (xtype == XPC_TYPE_DICTIONARY)
                [_self handleEvent:event];
            else if (xtype == XPC_TYPE_ERROR)
                [_self onError: event];
        });
        xpc_connection_resume(connection);
        xpc_connection_send_barrier(connection,^{});
    }
    return self;
}


-(void) onError: (xpc_object_t)event {
    NSLog(@"%@", event);
    [self exit];
}


- (void) licence:(NSData*)data {
    NSLog(@"%@", data);
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error || ![result isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", error);
        return;
    }
    [self setEnv:result forKey:@"licence"];
}

- (BOOL) checkLicence {
    NSDictionary* licence = [self getEnv:@"licence"];
    if (!licence) return NO;
    int valid = [[licence objectForKey:@"valid"] integerValue];
    return valid ? YES : NO;
}

- (void) start {
    [(id)self.proxy log:"运行脚本"];
    [(id)self.proxy isResumeBy: "开始"];
    NSLuaCore* core = [NSLuaCore sharedInstance];
    NSString* main = [NSString stringWithFormat:@"%@/main.lua", self.path];
    NSLuaTask* task = [core loadScript:main];
    [task dispatch:0];
}


- (void) stop {
    [(id)self.proxy isStopBy: "停止"];
    [self exit];
}


-(void) exit {
    if (self.peer) {
        [(id)self.proxy log:"脚本已停止"];
        xpc_connection_send_barrier(self.peer,^{
            exit(0);
        });
    } else {
        exit(0);
    }
}



@end
