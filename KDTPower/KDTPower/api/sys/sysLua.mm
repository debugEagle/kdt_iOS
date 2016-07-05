//
//  keyLua.c
//
//
//  Created by wd on 16/6/1.
//
//

#include "sysLua.h"
#include "Touch.h"
#include "Touch.h"
#include "Graphics.h"
#include "HPScriptClient.h"
#include "conf.h"
#import "UIKit/UIKit.h"


static
int sys_init(lua_State *L) {
    if (lua_gettop(L) != 1) {
        luaL_error(L, "%s 参数数量不足", __func__);
    }
    int index = lua_tonumber(L, 1);
    Touch::setRotation(index);
    Graphics::setRotation(index);
    return 0;
}


static
int sys_log (lua_State * L) {
    const char* text = lua_tostring(L, 1);
    if (!text) text = "nil";
    NSLog(@"%@", NS_String(text));
    HPScriptClient* client = [HPScriptClient sharedInstance];
    [(id)client.proxy log:(char*)text];
    return 0;
}


static
int sys_osver (lua_State * L) {
    NSString* ver = [[UIDevice currentDevice] systemVersion];
    lua_pushstring(L, [ver UTF8String]);
    return 1;
}


#warning 口袋图版本
static
int sys_kdtver (lua_State * L) {
    lua_pushstring(L, "1.0");
    return 1;
}


static struct luaL_Reg sys_fun[] = {
    { "init", sys_init},
    { "log", sys_log},
    { "version", sys_osver},
    { "kdtVersion", sys_kdtver},
    { NULL , NULL }
};


int luaopen_sys (lua_State* L) {
    luaL_newlib(L, sys_fun);
    lua_setglobal(L, "System");
    return 0;
}
