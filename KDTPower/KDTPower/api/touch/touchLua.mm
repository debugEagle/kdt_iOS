//
//  touchLua.c
//
//
//  Created by wd on 16/6/1.
//
//

#include "touchLua.h"
#include "Touch.h"
#include "conf.h"

int touch_down(lua_State *L) {
    int index = 0;
    int x = 0;
    int y = 0;
    
    if (lua_gettop(L) == 3) {
        index = lua_tonumber(L, 1);
        x = lua_tonumber(L, 2);
        y = lua_tonumber(L, 3);
    }
    else if (lua_gettop(L) == 2){
        x = lua_tonumber(L, 1);
        y = lua_tonumber(L, 2);
    }
    else {
        //[(id)[helper proxy] log:"touchDown 参数错误"];
        return 0;
    }
    Touch::touch(index, TOUCH_DOWN, x, y);
    NSLog(@"touchDown %d,%d,%d\n",index,x,y);
    return 0;
}


int touch_move(lua_State *L) {
    int index = 0;
    int x = 0;
    int y = 0;
    
    if (lua_gettop(L) == 3) {
        index = lua_tonumber(L, 1);
        x = lua_tonumber(L, 2);
        y = lua_tonumber(L, 3);
    }
    else if (lua_gettop(L) == 2){
        x = lua_tonumber(L, 1);
        y = lua_tonumber(L, 2);
    }
    else {
        //[(id)[helper proxy] log:"touchMove 参数错误"];
        return 0;
    }
    
    Touch::touch(index, TOUCH_MOVE, x, y);
    NSLog(@"touchMove %d,%d,%d\n",index,x,y);
    return 0;
}


int touch_up(lua_State *L) {
    int index = 0;
    int x = 0;
    int y = 0;
    
    if (lua_gettop(L) == 3) {
        index = lua_tonumber(L, 1);
        x = lua_tonumber(L, 2);
        y = lua_tonumber(L, 3);
    }
    else if (lua_gettop(L) == 2) {
        x = lua_tonumber(L, 1);
        y = lua_tonumber(L, 2);
    }
    else {
        //[(id)[helper proxy] log:"touchUp 参数错误"];
        return 0;
    }
    
    Touch::touch(index, TOUCH_UP, x, y);
    NSLog(@"touchUp %d,%d,%d\n",index,x,y);
    return 0;
}

int luaopen_touch (lua_State* L) {
    luaL_newlib(L, touch_fun);
    lua_setglobal(L, "Touch");
    return 0;
}