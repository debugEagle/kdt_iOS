//
//  screenLua.h
//  
//
//  Created by wd on 16/6/1.
//
//

#ifndef ____screenLua__
#define ____screenLua__

#ifdef __cplusplus
extern "C" {
#endif
    
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
    
    int screen_init(lua_State *L);
    int screen_size(lua_State *L);
    int screen_lock(lua_State *L);
    int screen_unlock(lua_State *L);
    int screen_isLocked(lua_State *L);
    int screen_getColor(lua_State *L);
    int screen_getColorRGB(lua_State *L);
    int screen_findColorEx(lua_State *L);
    
    static struct luaL_Reg screen_fun[] = {
        { "init", screen_init},
        { "size", screen_size},
        { "lock", screen_lock},
        { "unlock", screen_unlock},
        { "isLocked", screen_isLocked},
        { "getColor", screen_getColor},
        { "getColorRGB", screen_getColorRGB},
        { "findColorEx", screen_findColorEx},
        { NULL , NULL }
    };
    
    int luaopen_screen (lua_State* L);
    
#ifdef __cplusplus
}
#endif


#endif /* defined(____screenLua__) */
