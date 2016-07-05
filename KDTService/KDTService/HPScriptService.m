//
//  HPSciptService.m
//  KDTService
//
//  Created by wd on 16-3-27.
//
//

#import "HPScriptService.h"
#import "HPLocalService.h"
#import "HPSpringBoardService.h"
#import "KDTLicenceManager.h"
#import "LogManager.h"

@implementation HPScriptService

+(id) sharedInstance {
    static HPScriptService* _serivce;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _serivce = [[HPScriptService alloc] init];
    });
    return _serivce;
}


-(id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void) log:(char*) string {
    [LogManager append:NS_String(string)];
}


- (void) isReady:(char*) path {
    [(id)self.proxy start];
}


- (void) isResumeBy:(char*) reson {
    HPSpringBoardService* sbs = [HPSpringBoardService sharedInstance];
    [(id)sbs.proxy isResumeBy:reson];
    [LogManager append:NS_String(reson)];
}


- (void) isSuspendBy:(char*) reson {
    HPSpringBoardService* sbs = [HPSpringBoardService sharedInstance];
    [(id)sbs.proxy isSuspendBy:reson];
    [LogManager append:NS_String(reson)];
}


- (void) isStopBy:(char*) reson {
    WDLog("%@", NS_String(reson));
    [self setEnv:nil forKey:kStutsRuning];
    HPSpringBoardService* sbs = [HPSpringBoardService sharedInstance];
    [(id)sbs.proxy isStopBy:reson];
    [LogManager append:NS_String(reson)];
}


@end

int  HPScriptSerivce_init(void) {
    xpc_connection_t service = xpc_connection_create_mach_service(HPScriptServiceName,
                                                                  dispatch_get_main_queue(),
                                                                  XPC_CONNECTION_MACH_SERVICE_LISTENER);
    if (!service) {
        NSLog(@"%s Failed!",HPControlServiceName);
        return -1;
    }
    
    [HPScriptService sharedInstance];
    
    xpc_connection_set_event_handler(service, ^(xpc_object_t connection) {
        HPScriptSerivce_event_handler(connection);
    });
    xpc_connection_resume(service);
    WDLog("init");
    return 0;
}

void HPScriptSerivce_event_handler(xpc_connection_t peer) {
    if (xpc_get_type(peer) != XPC_TYPE_CONNECTION) {
        NSLog(@"%s have a error peer:%@",HPScriptServiceName,peer);
        xpc_release(peer);
        return;
    }
    __block HPScriptService* service = [HPScriptService sharedInstance];
    if (service.proxy) {
        goto err;
    };
    
    if (![service getEnv:kStutsWaiting]) {
        [LogManager append:@"不欢迎的连接 或者被取消的连接"];
        WDLog("不欢迎的连接 或者被取消的连接");
        goto err;
    }
    
    WDLog("创建了一个新的HPScriptSerivce");
    [LogManager append:@"脚本已链接HP"];
    NSXPCProxy* proxy = [[[NSXPCProxy alloc]initWithProto:@protocol(ScriptClientProtocol)
                                                 withPeer:peer] autorelease];
    service.proxy = proxy;
    [service setEnv:nil forKey:kStutsWaiting];            //取消等待连接标识
    [service setEnv:onStuts forKey:kStutsRuning];         //设置运行标识
    xpc_connection_set_event_handler(peer, ^(xpc_object_t event) {
        HPScriptSerivce_peer_event_handler(event,^{
            /* 脚本进程结束或者崩溃 */
            if ([service getEnv:kStutsRuning]) {
                HPSpringBoardService* sbs = [HPSpringBoardService sharedInstance];
                [LogManager append:@"脚本异常终止!"];
                [(id)sbs.proxy isStopBy:"脚本异常终止!"];
            }
            service.proxy = nil;
        });
    });
    xpc_connection_resume(peer);
    return;
    
err:
    xpc_connection_cancel(peer);
}

void HPScriptSerivce_peer_event_handler(xpc_object_t event,
                                        void (^error)() )
{
    xpc_type_t xtype = xpc_get_type(event);
    if (xtype == XPC_TYPE_ERROR) {
        WDLog("HPScriptSerivce invaild");
        error();
    } else {
        assert(xtype == XPC_TYPE_DICTIONARY);
        char *msg = xpc_copy_description(event);
        WDLog("%s have receive the data is %s",HPScriptServiceName,msg);
        free(msg);
        HPScriptService* service = [HPScriptService sharedInstance];
        [service handleEvent:event];
    }
}