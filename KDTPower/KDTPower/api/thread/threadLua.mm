//
//  keyLua.c
//
//
//  Created by wd on 16/6/1.
//
//

#include "threadLua.h"
#import "NSLuaTask.h"


static
int thread_current(lua_State *L) {
    WDLog(".");
    NSLuaTask* task = *(id*)lua_getextraspace(L);
    if (!task) {
        lua_pushnil(L);
        return 1;
    }
    
    lua_rawgetp(L, LUA_REGISTRYINDEX, task);
    assert(lua_istable(L, -1));
    lua_pushstring(L, "userdata");
    lua_rawget(L, -2);
    return 1;
}


static
int thread_create(lua_State *L) {
    NSLuaTask* task = *(id*)lua_getextraspace(L);
    NSLuaTask* newtask = [[[NSLuaTask alloc] initWithCore:task.delegate] autorelease];
    if (lua_gettop(L) == 2 && lua_isfunction(L, 2)) {
        [newtask setupCallBack:L];
    }
    
    if (lua_isfunction(L, 1)) {
        lua_pushvalue(L, 1);
        [newtask loadClosure:L];
    } else {
        const char* path = luaL_checkstring(L, 1);
        [newtask loadScript:NS_String(path)];
    }
    
    [newtask dispatch:0];
    
    lua_rawgetp(L, LUA_REGISTRYINDEX, newtask);
    assert(lua_istable(L, -1));
    lua_pushstring(L, "userdata");
    lua_rawget(L, -2);
    
    return 1;
}


static
int thread_gc(lua_State *L) {
    NSLuaTask* task = *(id*)luaL_checkudata(L, 1, THREAD_METATABLE);
    [task release];
    WDLog("%@:%d", task.path, [task retainCount]);
    return 0;
}


static
int thread_concat(lua_State *L) {
    const char* left = luaL_tolstring(L, 1, NULL);
    const char* right = luaL_tolstring(L, 2, NULL);
    NSString* connat = [NSString stringWithFormat:@"%@%@", NS_String(left), NS_String(right)];
    lua_pushstring(L, [connat UTF8String]);
    return 1;
}


static
int thread_tostring(lua_State *L) {
    NSLuaTask* task = *(id*)luaL_checkudata(L, 1, THREAD_METATABLE);
    lua_pushstring(L, [task.path UTF8String]);
    return 1;
}


static
int thread_kill(lua_State *L) {
    NSLuaTask* task = *(id*)luaL_checkudata(L, 1, THREAD_METATABLE);
    int ret = [task kill];
    lua_pushboolean(L, ret);
    return 1;
}


static
int thread_status(lua_State* L) {
    WDLog(".");
    NSLuaTask* task = *(id*)luaL_checkudata(L, 1, THREAD_METATABLE);
    NSString* status = [task getEnv:kStuts];
    lua_pushstring(L, [status UTF8String]);
    return 1;
}

static
int thread_sleep(lua_State *L) {
    /* 在autoreleasePool 中使用yield 会内存泄露 */
    int time = luaL_checkint(L, 1);
    NSLuaTask* task = *(id*)lua_getextraspace(L);
    [task dispatch:time];
    return lua_yield(L, 0);
}


static
struct luaL_Reg thread_fun[] = {
    { "current", thread_current},
    { "sleep", thread_sleep},
    { "create", thread_create},
    { "status", thread_status},
    { "kill", thread_kill},
    { NULL , NULL }
};


static
struct luaL_Reg tlib[] = {
    { "status", thread_status},
    { "kill", thread_kill},
    { "__gc", thread_gc},
    { "__concat", thread_concat},
    { "__tostring", thread_tostring},
    { NULL , NULL }
};


static
void createmeta(lua_State *L) {
    luaL_newmetatable(L, THREAD_METATABLE);
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, tlib, 0);
    lua_pop(L, 1);
}


int luaopen_thread (lua_State* L) {
    createmeta(L);
    luaL_newlib(L, thread_fun);
    lua_setglobal(L, "Thread");
    return 0;
}

