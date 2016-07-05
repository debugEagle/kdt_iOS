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
#import <xpc/xpc.h>
#import "HPProtocol.h"



@interface HPSpringBoardService : XPCSerivce<SpringBoardServiceProtocol>

@property (nonatomic,retain) NSXPCProxy* proxy;

+(id) sharedInstance;

@end


int  HPSpringBoardService_init(void);
void HPSpringBoardService_event_handler(xpc_connection_t peer);
void HPSpringBoardService_peer_event_handler(xpc_object_t event,void (^error)());