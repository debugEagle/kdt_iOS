//
//  touchLua.h
//  
//
//  Created by wd on 16/6/1.
//
//

#ifndef ____keyLua__
#define ____keyLua__

#ifdef __cplusplus
extern "C" {
#endif
    
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
    
    int key_down(lua_State *L);
    int key_up(lua_State *L);
    
    static struct luaL_Reg key_fun[] = {
        { "down", key_down},
        { "up", key_up},
        { NULL , NULL }
    };
    
    int luaopen_key (lua_State* L);
    
#ifdef __cplusplus
}
#endif

#endif /* defined(____keyLua__) */
