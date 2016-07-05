//
//  HPSerivce.h
//  KDTService
//
//  Created by wd on 16-3-27.
//
//

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>


#define onStuts          @"on"


@interface XPCSerivce : NSObject

-(id) init;
-(void) handleEvent:(xpc_object_t)event;

-(NSDictionary*) ENV;
-(id) getEnv:(id) key;
-(void) setEnv:(id) value forKey:(id) key;

@end
