//
//  NSLuaApi.h
//  PickMoney
//
//  Created by wd on 15-10-24.
//
//

#import <Foundation/Foundation.h>
#import "3rd/lua/lua.hpp"
#import "NSLuaTask.h"


@interface NSLuaCore: NSObject <LuaTaskDelegate>

+(id) sharedInstance;

-(void) openApi:(lua_CFunction) openf;
-(NSLuaTask*) loadScript:(NSString*) path;
-(void) resume;
-(void) suspend;

@end

