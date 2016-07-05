//
//  threadLua.h
//
//
//  Created by wd on 16/6/1.
//
//

#ifndef ____threadLua__
#define ____threadLua__

#ifdef __cplusplus
extern "C" {
#endif
    
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
    
    #define THREAD_METATABLE "THREAD"
    
    @class NSLuaTask;
    
    int luaopen_thread (lua_State* L);
    
#ifdef __cplusplus
}
#endif

#endif /* defined(____threadLua__) */
