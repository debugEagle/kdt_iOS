//
//  HPLocalSerivce.m
//  KDTService
//
//  Created by wd on 16-3-27.
//
//

#import "HPSpringBoardService.h"
#import "HPLocalService.h"
#import "HPScriptService.h"
#import "KDTLicenceManager.h"
#import "LogManager.h"
#import <xpc.h>
#import <spawn.h>

@implementation HPSpringBoardService


+(id) sharedInstance {
    static HPSpringBoardService* _serivce;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _serivce = [[HPSpringBoardService alloc] init];
    });
    return _serivce;
}


-(id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void) login {
    [LogManager append:@"boardService 登录"];
    [(id)self.proxy onLogin];
}

static
void _open() {
    HPScriptService* ss = [HPScriptService sharedInstance];
    if (ss.proxy) {
        [LogManager append:@"脚本已经运行"];
        return;
    }
    
    if ([ss getEnv:kStutsWaiting]) {
        [LogManager append:@"脚本已运行,等待连接"];
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
    char path[256] = "/usr/bin/KDTPower";
    int ret = posix_spawnp(&pid, path, &fact, &attr, (char**)args, (char**)environ);
    //waitpid(pid, &stat, WNOHANG);
    [LogManager append:@"启动脚本:%d,%d", ret, pid];
}

- (void) open {
    if ([self getEnv:kStutsVerify]) {
        [LogManager append:@"等待验证状态"];
        return;
    }
    /* 设置验证状态 */
    [self setEnv:onStuts forKey:kStutsVerify];
    KDTLicenceManager* licenceManager = [KDTLicenceManager sharedInstance];
    [licenceManager updateLicence:^(NSDictionary* licence) {
        /* 清除验证状态 */
        [self setEnv:nil forKey:kStutsVerify];
        
        NSDictionary* payload = [licence objectForKey:@"payload"];
        NSNumber* valid = [payload objectForKey:@"valid"];
        if (!valid) {
            [LogManager append:@"鉴权失败,请检查网络!"];
            [(id)self.proxy showText:"鉴权失败,请检查网络!"];
            return;
        }
        if ([valid isEqualToNumber:@1]) {
            [LogManager append:@"发送开启脚本命令"];
            return _open();
        }
        [(id)self.proxy showText:"授权过期!"];
    }];
}


- (void) close {
    HPScriptService* ss = [HPScriptService sharedInstance];
    [(id)ss.proxy stop];
    [LogManager append:@"发送停止脚本命令"];
}

@end



int  HPSpringBoardService_init(void) {
    xpc_connection_t service = xpc_connection_create_mach_service(HPSpringBoardServiceName,
                                                                  dispatch_get_main_queue(),
                                                                  XPC_CONNECTION_MACH_SERVICE_LISTENER);
    if (!service) {
        NSLog(@"%s Failed!",HPControlServiceName);
        return -1;
    }
    [HPSpringBoardService sharedInstance];
    //设置服务的回调，每次有新的远程链接创建时，调用次链接
    xpc_connection_set_event_handler(service, ^(xpc_object_t connection) {
        HPSpringBoardService_event_handler(connection);
    });
    //创建链接后要启动
    xpc_connection_resume(service);
    WDLog("init");
    return 0;
}


void HPSpringBoardService_event_handler(xpc_connection_t peer) {
    if (xpc_get_type(peer) != XPC_TYPE_CONNECTION) {
        NSLog(@"%s have a error peer:%@",HPControlServiceName,peer);
        xpc_release(peer);
        return;
    }
    __block HPSpringBoardService* serivce = [HPSpringBoardService sharedInstance];
    if (serivce.proxy) {      //如果sb已经联入了
        [LogManager append:@"boardService 重复登录"];
        goto err;
    };
    /* 创建控制端代理，此处的协议 是arhp向远方控制端远程调用的协议 */
    NSXPCProxy* proxy = [[[NSXPCProxy alloc] initWithProto:@protocol(SpringBoardClientProtocol)
                                                  withPeer:peer] autorelease];
    serivce.proxy = proxy;
    
    /* 设置回调，每次连接收到消息的时候调用。设置下出错处理函数，直接将代理设置为nil即可 */
    xpc_connection_set_event_handler(peer, ^(xpc_object_t event) {
        HPSpringBoardService_peer_event_handler(event,^{
            [LogManager append:@"boardService 断开"];
            serivce.proxy = nil;
        });
    });
    [LogManager append:@"boardService 连接"];
    xpc_connection_resume(peer);
    return;
    
err:
    xpc_connection_cancel(peer);
    
}

//peer收到消息的回调
void HPSpringBoardService_peer_event_handler(xpc_object_t event,
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
        HPSpringBoardService* serivce = [HPSpringBoardService sharedInstance];
        [serivce handleEvent:event];       //没有错误则处理消息
    }
}




