//
//  HPScriptClient.m
//  KDTPower
//
//  Created by wd on 16-3-28.
//
//

#import "HPWindowClient.h"
#import "KDTWindow.h"

@implementation HPWindowClient


+(id) sharedInstance {
    static HPWindowClient* _serivce;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _serivce = [[HPWindowClient alloc] init];
    });
    return _serivce;
}


-(id) init {
    self = [super init];
    if (self) {
        [self setEnv:NS_Int(0) forKey:@"rc"];
        [self setEnv:NS_Int(0) forKey:@"isLogin"];
        [self connect];
    }
    return self;
}


-(void) connect {
    WDLog(".");
    if (self.proxy) return;
    
    int rc = [[self getEnv:@"rc"] intValue];
    NSLog(@"第%d次重新连接", rc);
    xpc_connection_t connection = xpc_connection_create_mach_service(HPSpringBoardServiceName,
                                                                     dispatch_get_main_queue(),
                                                                     0);
    if (!connection) {
        WDLog("Failed to create service.");
        return;
    }
    NSXPCProxy* proxy = [[[NSXPCProxy alloc] initWithProto:@protocol(SpringBoardServiceProtocol)
                                                  withPeer:connection] autorelease];
    self.proxy = proxy;
    self.peer = connection;
    
    __block id _self = self;
    xpc_connection_set_event_handler(connection, ^(xpc_object_t event) {
        xpc_type_t xtype = xpc_get_type(event);
        if (xtype == XPC_TYPE_DICTIONARY)
            [_self handleEvent:event];
        else if (xtype == XPC_TYPE_ERROR) {
            xpc_connection_cancel(connection);
            [_self onError: event];
        }
    });
    xpc_connection_resume(connection);
    xpc_connection_send_barrier(connection,^{});
    [(id)self.proxy login];
}

-(void) onError: (xpc_object_t)event {
    //xpc_release(self.peer); //崩溃
    WDLog("%@", event);
    int isLogin = [[self getEnv:@"isLogin"] intValue];
    if (isLogin) {
        KDTWindow* window = [KDTWindow sharedInstance];
        [window showText:@"[口袋助手] 服务异常终止!"];
        [window menuVisible:0];
        [window menuRotate:0];
    }
    int rc = [[self getEnv:@"rc"] intValue];
    [self setEnv:NS_Int(rc + 1) forKey:@"rc"];
    [self setEnv:NS_Int(0) forKey:@"isLogin"];
    
    self.proxy = nil;
    self.peer = nil;
    int64_t sleep = rc * 2000 * NSEC_PER_MSEC;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sleep), dispatch_get_main_queue(), ^{
        [self connect];
    });
}


-(void) onLogin {
    [self setEnv:NS_Int(0) forKey:@"rc"];
    [self setEnv:NS_Int(1) forKey:@"isLogin"];
    KDTWindow* window = [KDTWindow sharedInstance];
    [window showText:@"[口袋助手] 服务连接成功!"];
}


-(void) menuVisible:(int) op {
    KDTWindow* window = [KDTWindow sharedInstance];
    [window menuVisible:op];
}


-(void) menuVisibleChange {
    KDTWindow* window = [KDTWindow sharedInstance];
    [window menuVisibleChange];
}


- (void) isResumeBy:(char*)reson {
    KDTWindow* window = [KDTWindow sharedInstance];
    [window isResumeBy: reson];
}

- (void) showText:(char*) text {
    KDTWindow* window = [KDTWindow sharedInstance];
    [window showText: NS_String(text)];
}

- (void) isSuspendBy:(char*)reson {
    KDTWindow* window = [KDTWindow sharedInstance];
    [window isSuspendBy: reson];
}


- (void) isStopBy:(char*)reson {
    KDTWindow* window = [KDTWindow sharedInstance];
    [window menuVisible:YES];
    [window isStopBy: reson];
}

@end
