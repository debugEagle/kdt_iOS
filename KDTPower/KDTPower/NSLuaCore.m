//
//  NSLuaApi.m
//  PickMoney
//
//  Created by wd on 15-10-24.
//
//

#import "NSLuaCore.h"
#import "threadLua.h"
#import "HPScriptClient.h"
#include "KDTApi.h"

@implementation NSLuaCore {
    lua_State*              main;
    NSMutableDictionary*    tasks;
    dispatch_queue_t        queue;
}


+(id) sharedInstance {
    static NSLuaCore* _core;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _core = [[NSLuaCore alloc] init];
    });
    return _core;
}


-(id) init {
    self = [super init];
    if (self) {
        main = luaL_newstate();
        luaL_openlibs(main);
        tasks = [[NSMutableDictionary alloc] init];
        queue = dispatch_queue_create("luacore", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


-(void) openApi:(lua_CFunction) openf {
    openf(main);
}


static
int __defaultCallBack(lua_State* L) {
    WDLog(".");
    if (lua_isstring(L, -1)) {
        size_t size = 0;
        const char* error = lua_tolstring(L, -1, &size);
        HPScriptClient* client = [HPScriptClient sharedInstance];
        [(id)client.proxy isStopBy:(char*) error];
        [client exit];
    }
    return 0;
}


-(NSLuaTask*) loadScript:(NSString*) path {
    @autoreleasepool {
        NSLuaTask *task = [[[NSLuaTask alloc] initWithCore:self] autorelease];
        [task loadScript:path];
        return task;
    }
}


-(void) evoke:(NSLuaTask*) task {
    const char* error = nil;
    size_t size = 0;
    HPScriptClient* client = [HPScriptClient sharedInstance];
    
    lua_rawgetp(main, LUA_REGISTRYINDEX, task);
    assert(lua_istable(main, -1));
    /*
    if (!lua_istable(main, -1)) {
        error = "task table expect a table";
        goto err;
    }*/
    
    lua_pushstring(main, "callback");
    lua_rawget(main, -2);
    
    if (!lua_isfunction(main, -1))
        return lua_pop(main, 4);
    lua_remove(main, -2);   /* remove the taks table */
    lua_insert(main, -3);   /* adjust */
    int ret = lua_pcall(main, 2, 0, 0);
    if (ret == LUA_OK) return;
    if (ret != LUA_YIELD) error = lua_tolstring(main, -1, &size);
    if (ret == LUA_YIELD) error = "can't sleep(yield) in callback :(";
    
err:
    [(id)client.proxy isStopBy:(char*) error];
    [client exit];
}


-(void) resume {
    dispatch_resume(queue);
}


-(void) suspend {
    dispatch_suspend(queue);
}


-(NSLuaTask*) getTask:(lua_State*) L {
    id key = [NSValue valueWithPointer:L];
    return [tasks objectForKey:key];
}


-(lua_State*) creatThread:(NSLuaTask*) task {
    lua_newtable(main);
    
    /* coroutine */
    lua_pushstring(main, "coroutine");
    lua_State* L = lua_newthread(main);
    lua_rawset(main, -3);
    
    /* userdata */
    lua_pushstring(main, "userdata");
    id* u = (id*)lua_newuserdata(main, sizeof(id*));
    *u = [task retain];
    luaL_setmetatable(main, THREAD_METATABLE);
    lua_rawset(main, -3);
    
    /* callback */
    lua_pushstring(main, "callback");
    lua_pushcfunction(main, __defaultCallBack);
    lua_rawset(main, -3);
    
    lua_rawsetp(main, LUA_REGISTRYINDEX, task);
    
    id key = [NSValue valueWithPointer:L];
    [tasks setObject:task forKey:key];
    return L;
}


-(dispatch_queue_t) dispatchQueue {
    return queue;
}


-(void) destroy:(NSLuaTask*) task {
    /* clearup */
    lua_pushnil(main);
    lua_rawsetp(main, LUA_REGISTRYINDEX, task);
    
    //luaE_freethread(main, task.L);
    /* remove task */
    id key = [NSValue valueWithPointer:task.L];
    [tasks removeObjectForKey:key];
    WDLog("task:%d", [task retainCount]);
    
    /* all task done */
    if (!tasks.count) {
        HPScriptClient* client = [HPScriptClient sharedInstance];
        [(id)client.proxy isStopBy:"运行完成"];
        [client exit];
    }
}


-(void) taskRunError:(NSLuaTask*) task {
    WDLog(".");
    lua_pushboolean(main, 0);
    lua_xmove(task.L, main, 1);
    [self evoke:task];
    [self destroy:task];
}


-(void) taskEnd:(NSLuaTask*) task {
    lua_pushboolean(main, 0);
    lua_pushnil(main);
    [self evoke:task];
    [self destroy:task];
}


-(void) taskKill:(NSLuaTask*)task {
    lua_pushboolean(main, 1);
    lua_pushnil(main);
    [self evoke:task];
    [self destroy:task];
}


@end
