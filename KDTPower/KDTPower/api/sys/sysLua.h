//
//  touchLua.h
//  
//
//  Created by wd on 16/6/1.
//
//

#ifndef ____sysLua__
#define ____sysLua__

#ifdef __cplusplus
extern "C" {
#endif
    
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
    
    int luaopen_sys (lua_State* L);
    
#ifdef __cplusplus
}
#endif

#endif /* defined(____keyLua__) */
