//
//  keyLua.c
//
//
//  Created by wd on 16/6/1.
//
//

#include "keyLua.h"
#include "Touch.h"

int key_down(lua_State *L) {
    if (lua_gettop(L) != 1) {
        luaL_error(L, "%s 参数数量不足", __func__);
    }
    int type = lua_tonumber(L, 1);
    Touch::key(type,1);
    return 0;
}


int key_up(lua_State *L) {
    if (lua_gettop(L) != 1) {
        luaL_error(L, "%s 参数数量不足", __func__);
    }
    int type = lua_tonumber(L, 1);
    Touch::key(type,0);
    return 0;
}


const char* key_press = "return "\
"function (type, delay)\n"\
    "local _type = tonumber(type)\n"\
    "local _delay = tonumber(delay)\n"\
    "Key.down(_type)\n"\
    "Thread.sleep(_delay)\n"\
    "Key.up(_type)\n"\
"end\n";


int luaopen_key (lua_State* L) {
    luaL_newlib(L, key_fun);
    lua_pushstring(L, "press");
    luaL_dostring(L, key_press);
    WDLog("%@", NS_String(key_press));
    lua_rawset(L, -3);
    lua_setglobal(L, "Key");
    return 0;
}