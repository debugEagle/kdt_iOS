//
//  appLua.c
//
//
//  Created by wd on 16/6/1.
//
//

#include "appLua.h"
#include "PrivateHeader.h"
#include "conf.h"

int app_run(lua_State *L) {
    const char* bid = luaL_checkstring(L,1);
    int ret = SBSLaunchApplicationWithIdentifier(NS_String(bid), 0);
    lua_pushinteger(L, ret);
    return 1;
}


int app_close(lua_State *L) {
    int pid = 0;
    if (lua_type(L, 1) == LUA_TNUMBER) {
        pid = luaL_checkinteger(L, 1);
    } else {
        const char* bid = luaL_checkstring(L, 1);
        SBSProcessIDForDisplayIdentifier(NS_String(bid), &pid);
    }
    int ret = kill(pid, 9);
    lua_pushboolean(L, !ret);
    return 1;
}


int app_isRunning(lua_State *L) {
    int pid = 0;
    const char* bid = luaL_checkstring(L,1);
    SBSProcessIDForDisplayIdentifier(NS_String(bid), &pid);
    lua_pushboolean(L, pid);
    return 1;
}


int app_bid2pid(lua_State *L) {
    int pid = 0;
    const char* bid = luaL_checkstring(L,1);
    SBSProcessIDForDisplayIdentifier(NS_String(bid), &pid);
    lua_pushinteger(L, pid);
    return 1;
}


int app_pid2bid(lua_State *L) {
    int pid = luaL_checkinteger(L, 1);
    NSString* bid = [SBSCopyDisplayIdentifierForProcessID(pid) autorelease];
    if (!bid) bid = @"";
    lua_pushstring(L, [bid UTF8String]);
    return 1;
}


int app_frontBid(lua_State *L) {
    NSString* bid = [SBSCopyFrontmostApplicationDisplayIdentifier() autorelease];
    if (!bid) bid = @"com.apple.springboard";
    lua_pushstring(L, [bid UTF8String]);
    return 1;
}


int luaopen_app (lua_State* L) {
    luaL_newlib(L, app_fun);
    lua_setglobal(L, "App");
    return 0;
}