//
//  screenLua.m
//  
//
//  Created by wd on 16/6/1.
//
//

#include "screenLua.h"
#include "Touch.h"
#include "Graphics.h"
#include "conf.h"
#import "HPScriptClient.h"

int screen_init(lua_State *L) {
    if (lua_gettop(L) != 1) {
        luaL_error(L, "%s 参数数量不足", __func__);
    }
    int index = lua_tonumber(L, 1);
    Touch::setRotation(index);
    Graphics::setRotation(index);
    return 0;
}

int screen_size(lua_State *L) {
    int width = 0;
    int height = 0;
    Graphics::getScreenSize(&width, &height);
    lua_pushinteger(L, width);
    lua_pushinteger(L, height);
    return 2;
}


int screen_lock(lua_State *L) {
    Graphics::keepScreen(true);
    return 0;
}


int screen_unlock(lua_State *L) {
    Graphics::keepScreen(false);
    return 0;
}


int screen_isLocked(lua_State *L) {
    bool b = Graphics::keepStatus();
    lua_pushboolean(L, b);
    return 1;
}


int screen_getColor(lua_State *L) {
    if (lua_gettop(L) != 2) {
        luaL_error(L, "%s 参数数量不足", __func__);
        return 1;
    }
    int x = lua_tointeger(L, 1);
    int y = lua_tointeger(L, 2);
    int ret = Graphics::getColor(x,y);
    lua_pushinteger(L, ret&0xffffff);
    return 1;
}


int screen_getColorRGB(lua_State *L) {
    if (lua_gettop(L) != 2) {
        luaL_error(L, "%s 参数数量不足", __func__);
        return 1;
    }
    int x = lua_tointeger(L, 1);
    int y = lua_tointeger(L, 2);
    int ret = Graphics::getColor(x,y);
    lua_pushinteger(L, GetR(ret));
    lua_pushinteger(L, GetG(ret));
    lua_pushinteger(L, GetB(ret));
    return 3;
}


int screen_findColorEx(lua_State *L) {
    if (lua_gettop(L) != 8) {
        luaL_error(L, "%s 参数数量不足", __func__);
        return 0;
    }
    
    size_t size = 0;
    int fistColor = lua_tointeger(L, 1);
    NSLog(@"first:%08x", fistColor);
    NSString* otherPoint = NS_String(lua_tolstring(L, 2, &size));
    int x1 = lua_tointeger(L, 3);
    int y1 = lua_tointeger(L, 4);
    int x2 = lua_tointeger(L, 5);
    int y2 = lua_tointeger(L, 6);
    double sim = lua_tonumber(L, 7);
    int dir = lua_tointeger(L, 8);
    int x,y;
    NSString* errmsg = Graphics::findColorEx(fistColor, otherPoint, x1, y1 ,x2, y2, sim, dir, &x, &y);
    if (errmsg) luaL_error(L, "%s %s", __func__, [errmsg UTF8String]);
    lua_pushinteger(L, x);
    lua_pushinteger(L, y);
    return 2;
}


int luaopen_screen (lua_State* L) {
    luaL_newlib(L, screen_fun);
    lua_setglobal(L, "Screen");
    return 0;
}