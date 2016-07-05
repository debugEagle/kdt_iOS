//
//  appLua.h
//  
//
//  Created by wd on 16/6/1.
//
//

#ifndef ____appLua__
#define ____appLua__

#ifdef __cplusplus
extern "C" {
#endif
    
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
    
    int app_run(lua_State *L);
    int app_close(lua_State *L);
    int app_isRunning(lua_State *L);
    int app_bid2pid(lua_State *L);
    int app_pid2bid(lua_State *L);
    int app_frontBid(lua_State *L);
    
    static struct luaL_Reg app_fun[] = {
        { "run", app_run},
        { "close", app_close},
        { "isRunning", app_isRunning},
        { "bid2pid", app_bid2pid},
        { "pid2bid", app_pid2bid},
        { "frontBid", app_frontBid},
        { NULL , NULL }
    };
    
    int luaopen_app (lua_State* L);
    
#ifdef __cplusplus
}
#endif

#endif /* defined(____appLua__) */
