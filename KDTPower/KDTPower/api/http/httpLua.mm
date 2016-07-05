//
//  keyLua.c
//
//
//  Created by wd on 16/6/1.
//
//

#include "httpLua.h"
#include "conf.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSLuaTask.h"


int http_get(lua_State* L){
    const char* str = 0;
    int timeout = 0;
    
    str = luaL_checkstring(L, 1);
    timeout = lua_tointeger(L, 2);
    NSString* nsurl = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:nsurl]];
    __block NSLuaTask* task = [*(id*)lua_getextraspace(L) retain];
    
    if (lua_istable(L, 3)) {
        const char* k = nil;
        const char* v = nil;
        lua_pushnil(L);
        while (lua_next(L, 3) != 0) {
            v = luaL_checkstring(L, -1);
            k = luaL_checkstring(L, -2);
            [request addRequestHeader: NS_String(k)
                                value: NS_String(v)];
            lua_pop(L, 1);
        }
    }
    
    [request setTimeOutSeconds:timeout];
    [request setRequestMethod:@"GET"];
    
    [request setCompletionBlock:^{
        [task push:"%d%@%@",request.responseStatusCode,
         request.responseHeaders,
         request.responseData];
        [task dispatch:0];
        [task release];
        [request release];
    }];
    [request setFailedBlock:^{
        [task push:"%d",request.responseStatusCode];
        [task dispatch:0];
        [task release];
        [request release];
    }];
    [request startAsynchronous];
    return lua_yield(L,0);
}

int http_post(lua_State* L){
    const char* str = NULL;
    int timeout = 0;
    
    str = luaL_checkstring(L, 1);
    timeout = luaL_checkinteger(L, 2);
    NSString* nsurl = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
    __block ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:nsurl]];
    __block NSLuaTask* task = [*(id*)lua_getextraspace(L) retain];
    
    if (lua_istable(L, 3)) {
        const char* k = nil;
        const char* v = nil;
        lua_pushnil(L);
        while (lua_next(L, 3) != 0) {
            v = luaL_checkstring(L, -1);
            k = luaL_checkstring(L, -2);
            [request addRequestHeader:[NSString stringWithCString:k encoding:NSUTF8StringEncoding]
                                value:[NSString stringWithCString:v encoding:NSUTF8StringEncoding]];
            lua_pop(L, 1);
        }
    }
    
    if (lua_istable(L, 4)) {
        const char* k = nil;
        const char* v = nil;
        lua_pushnil(L);
        while (lua_next(L, 3) != 0) {
            v = luaL_checkstring(L, -1);
            k = luaL_checkstring(L, -2);
            [request setPostValue: [NSString stringWithCString:k encoding:NSUTF8StringEncoding]
                           forKey:[NSString stringWithCString:v encoding:NSUTF8StringEncoding]];
            lua_pop(L, 1);
        }
    }
    
    [request setTimeOutSeconds:timeout];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        [task push:"%d%@%@",request.responseStatusCode,
         request.responseHeaders,
         request.responseData];
        [task dispatch:0];
        
        [task release];
        [request release];
    }];
    [request setFailedBlock:^{
        [task push:"%d",request.responseStatusCode];
        [task dispatch:0];
        [task release];
        [request release];
    }];
    [request startAsynchronous];
    return lua_yield(L,0);
}


int luaopen_http (lua_State* L) {
    luaL_newlib(L, http_fun);
    lua_setglobal(L, "Http");
    return 0;
}