//
//  HPSciptService.h
//  KDTService
//
//  Created by wd on 16-3-27.
//
//

#import <Foundation/Foundation.h>
#import <XPCExt/NSXPCProxy.h>
#import <XPCExt/XPCSerivce.h>
#import "XPCSerivce.h"
#import "HPProtocol.h"


@interface HPScriptService : XPCSerivce<ScriptServiceProtocol>

@property (nonatomic,retain) NSXPCProxy* proxy;

+(id) sharedInstance;

@end


int  HPScriptSerivce_init(void);
void HPScriptSerivce_event_handler(xpc_connection_t peer);
void HPScriptSerivce_peer_event_handler(xpc_object_t event,void (^error)());