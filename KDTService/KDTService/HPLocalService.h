//
//  HPLocalSerivce.h
//  KDTService
//
//  Created by wd on 16-3-27.
//
//

#import <Foundation/Foundation.h>
#import <XPCExt/XPCSerivce.h>
#import <XPCExt/NSXPCProxy.h>
#import <xpc.h>
#import "HPProtocol.h"


@interface HPLocalService : XPCSerivce<LocalServiceProtocol>

@property (nonatomic,retain) NSXPCProxy* proxy;

+(id) sharedInstance;

- (void) open;                              //开始脚本
- (void) close;                             //停止脚本

@end


int  HPLocalSerivce_init(void);
void HPLocalSerivce_event_handler(xpc_connection_t peer);
void HPLocalSerivce_peer_event_handler(xpc_object_t event,void (^error)());