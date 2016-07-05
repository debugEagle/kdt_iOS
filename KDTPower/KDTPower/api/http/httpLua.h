//
//  httpLua.h
//  
//
//  Created by wd on 16/6/1.
//
//

#ifndef ____httpLua__
#define ____httpLua__

#ifdef __cplusplus
extern "C" {
#endif
    
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
    
    int http_get(lua_State* L);
    int http_post(lua_State* L);
    
    static struct luaL_Reg http_fun[] = {
        { "get", http_get},
        { "post", http_post},
        { NULL , NULL }
    };
    
    int luaopen_http (lua_State* L);
    
#ifdef __cplusplus
}
#endif

#endif /* defined(____keyLua__) */
