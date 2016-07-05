//
//  touchLua.h
//  
//
//  Created by wd on 16/6/1.
//
//

#ifndef ____touchLua__
#define ____touchLua__

#ifdef __cplusplus
extern "C" {
#endif
    
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
    
    int touch_down(lua_State *L);
    int touch_move(lua_State *L);
    int touch_up(lua_State *L);
    
    static struct luaL_Reg touch_fun[] = {
        { "down", touch_down},
        { "move", touch_move},
        { "up", touch_up},
        { NULL , NULL }
    };
    
    int luaopen_touch (lua_State* L);
    
#ifdef __cplusplus
}
#endif

#endif /* defined(____touchLua__) */
