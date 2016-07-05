//
//  HPScriptClient.m
//  KDTPower
//
//  Created by wd on 16-3-28.
//
//

#import "HPLocalClient.h"
#import <UIKit/UIKit.h>

@interface HPLocalClient()

@property (nonatomic, strong) NSMutableArray<onError>* errorBlocks;

@end

@implementation HPLocalClient


+(id) sharedInstance {
    static HPLocalClient* _serivce;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _serivce = [[HPLocalClient alloc] init];
    });
    return _serivce;
}


-(id) init {
    self = [super init];
    if (self) {
        _errorBlocks = [[NSMutableArray alloc] init];
        [self setEnv:NS_Int(0) forKey:@"rc"];
        [self setEnv:NS_Int(0) forKey:@"isLogin"];
        [self setEnv:nil forKey:@"status"];
        [self setEnv:nil forKey:@"licence"];
        [self connect];
    }
    return self;
}


-(void) connect {
    WDLog(".");
    if (self.proxy) return;
    
    int rc = [[self getEnv:@"rc"] intValue];
    NSLog(@"第%d次连接", rc);
    xpc_connection_t connection = xpc_connection_create_mach_service(HPControlServiceName,
                                                                     dispatch_get_main_queue(),
                                                                     0);
//    xpc_connection_t connection = xpc_connection_create_mach_service("com.apple.networkd1",
//                                                                     dispatch_get_main_queue(),
//                                                                     XPC_CONNECTION_MACH_SERVICE_PRIVILEGED);

    if (!connection) {
        WDLog("Failed to create service.");
        return;
    }
    NSXPCProxy* proxy = [[[NSXPCProxy alloc] initWithProto:@protocol(LocalServiceProtocol)
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

-(void) setErrorBlock:(onError) block {
    [self.errorBlocks addObject:[block copy]];
}

-(void) invokeErrorBlock {
    for (onError block in self.errorBlocks) {
        block();
    }
}

-(void) onError: (xpc_object_t)event {
    //xpc_release(self.peer); //崩溃
    WDLog("%@", event);
    int isLogin = [[self getEnv:@"isLogin"] intValue];
    if (isLogin) {
        [self invokeErrorBlock];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"服务异常终止!"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
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
    NSLog(@"%@", @"服务连接成功");
    [(id)self.proxy licence];
    [(id)self.proxy status];
}


- (void) onLicence:(NSDictionary*) licence {
    WDLog("%@",licence);
    [self setEnv:licence forKey:@"licence"];
    NSNotification * notice = [NSNotification notificationWithName:@"licenceChange" object:self userInfo:licence];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}


- (void) onStatus:(NSDictionary*)status {
    WDLog("%@",status);
    [self setEnv:status forKey:@"status"];
    NSNotification * notice = [NSNotification notificationWithName:@"statusChange" object:self userInfo:status];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}


@end
