//
//  HPLocalSerivce.m
//  KDTService
//
//  Created by wd on 16-3-27.
//
//

#import "HPLocalService.h"
#import "HPScriptService.h"
#import <xpc.h>
#import "IOHIDEvent.h"
#import "KDTLicenceManager.h"
#import "HPSpringBoardService.h"
#import "LogManager.h"
#import <spawn.h>

@implementation HPLocalService


+(id) sharedInstance {
    static HPLocalService* _serivce;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _serivce = [[HPLocalService alloc] init];
        IOHIDEvent_init();
    });
    return _serivce;
}


-(id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void) login {
    [(id)self.proxy onLogin];
}

- (void) licence {
    KDTLicenceManager* LM = [KDTLicenceManager sharedInstance];
    [LM updateLicence:^(NSDictionary* licence) {
        NSLog(@"%@", licence);
        [(id)self.proxy onLicence:licence];
    }];
}


- (void) status {
    [(id)self.proxy onStatus:[self ENV]];
}


-(void) startListen {
    if ([self getEnv:kStutsListening]) {
        [LogManager append:@"已经在监听了"];
        return;
    }
    /* 设置监听标记 */
    [self setEnv:onStuts forKey:kStutsListening];
    IOHIDEvent_startListen();
}


-(void) stopListen {
    HPSpringBoardService* sbs = [HPSpringBoardService sharedInstance];
    HPScriptService* ss = [HPScriptService sharedInstance];
    HPLocalService* ls = [HPLocalService sharedInstance];
    if (ss.proxy) {
        [LogManager append:@"脚本运行中，请先关闭脚本"];
        [(id)sbs.proxy showText:"脚本运行中，请先关闭脚本"];
        [(id)ls.proxy onStatus:[ls ENV]];
        return;
    }
    /* 取消监听标记 */
    [(id)sbs.proxy menuVisible:0];
    [self setEnv:nil forKey:kStutsListening];
    IOHIDEvent_stopListen();
}

- (void) open {
    HPScriptService* ss = [HPScriptService sharedInstance];
    if (ss.proxy) {
        [LogManager append:@"脚本已经运行"];
        return;
    }
    
    if ([ss getEnv:kStutsWaiting]) {
        [LogManager append:@"脚本已运行,等待链接"];
        return;
    }
    //脚本未运行,启动脚本
    [ss setEnv:onStuts forKey:kStutsWaiting];          //设置等待连接状态
    //int ret = system("KDTPower &");
    
    posix_spawnattr_t attr;
    posix_spawn_file_actions_t fact;
    posix_spawnattr_init(&attr);
    posix_spawn_file_actions_init(&fact);
    pid_t pid;
    int stat = 0;
    const char* args[2] = {"", NULL};
    const char* environ[2] = {"path=/usr/bin/a.lua", NULL};
    int ret = posix_spawnp(&pid, "/usr/bin/KDTPower", &fact, &attr, (char**)args, (char**)environ);
    [LogManager append:@"启动脚本:%d,%d", ret, pid];
}

- (void) close {
    HPScriptService* ss = [HPScriptService sharedInstance];
    [(id)ss.proxy close];
    [ss setEnv:nil forKey:kStutsWaiting];
}

@end




int  HPLocalSerivce_init(void) {
    xpc_connection_t service = xpc_connection_create_mach_service(HPControlServiceName,
                                                                  dispatch_get_main_queue(),
                                                                  XPC_CONNECTION_MACH_SERVICE_LISTENER);
    if (!service) {
        NSLog(@"%s Failed!",HPControlServiceName);
        return -1;
    }
    [HPLocalService sharedInstance];
    //设置服务的回调，每次有新的远程链接创建时，调用次链接
    xpc_connection_set_event_handler(service, ^(xpc_object_t connection) {
        HPLocalSerivce_event_handler(connection);
    });
    //创建链接后要启动
    xpc_connection_resume(service);
    WDLog("init");
    return 0;
}


void HPLocalSerivce_event_handler(xpc_connection_t peer) {
    if (xpc_get_type(peer) != XPC_TYPE_CONNECTION) {
        NSLog(@"%s have a error peer:%@",HPControlServiceName,peer);
        xpc_release(peer);
        return;
    }
    __block HPLocalService* serivce = [HPLocalService sharedInstance];
    if (serivce.proxy) {      //如果app已经联入了
        [LogManager append:@"localService 重复登录"];
        goto err;
    };
    /* 创建控制端代理，此处的协议 是arhp向远方控制端远程调用的协议 */
    NSXPCProxy* proxy = [[[NSXPCProxy alloc] initWithProto:@protocol(LocalClientProtocol)
                                                  withPeer:peer] autorelease];
    serivce.proxy = proxy;
    
    /* 设置回调，每次连接收到消息的时候调用。设置下出错处理函数，直接将代理设置为nil即可 */
    xpc_connection_set_event_handler(peer, ^(xpc_object_t event) {
        HPLocalSerivce_peer_event_handler(event,^{
            [LogManager append:@"localService 断开"];
            serivce.proxy = nil;
        });
    });
    [LogManager append:@"localService 已经连接"];
    xpc_connection_resume(peer);
    return;
    
err:
    xpc_connection_cancel(peer);
    
}

//peer收到消息的回调
void HPLocalSerivce_peer_event_handler(xpc_object_t event,
                                       void (^error)() )
{
    xpc_type_t xtype = xpc_get_type(event);
    if (xtype == XPC_TYPE_ERROR) {      //如果远端发生错误，则调用出错处理函数
        error();
    } else {
        assert(xtype == XPC_TYPE_DICTIONARY);
        char *msg = xpc_copy_description(event);
        WDLog("%s have receive the data is %s",HPControlServiceName,msg);
        free(msg);
        HPLocalService* serivce = [HPLocalService sharedInstance];
        [serivce handleEvent:event];       //没有错误则处理消息
    }
}




