//
//  keyLua.c
//
//
//  Created by wd on 16/6/1.
//
//

#include "settingLua.h"
#include "HPScriptClient.h"
#include "conf.h"

static
int setting_get(lua_State *L) {
    NSString* key = NS_String(luaL_checkstring(L, 1));
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:@"./settings.plist"];
    if (!dict)
        return 0;
    
    NSMutableDictionary* Settings = [dict objectForKey:@"Settings"];
    if (!Settings)
        return 0;
    
    id value = [Settings objectForKey:key];
    if (!value)
        return 0;
    
    CFTypeID type = CFGetTypeID(value);
    if (type == CFStringGetTypeID()) {
        const char* vchar = [value UTF8String];
        lua_pushstring(L,vchar);
        return 1;
    }
    
    if (type == CFNumberGetTypeID()) {
        double vnumber = [value doubleValue];
        lua_pushnumber(L, vnumber);
        return 1;
    }
    
    if (type == CFBooleanGetTypeID()) {
        BOOL vbool = [value boolValue];
        lua_pushboolean(L, vbool);
        return 1;
    }
    return 0;
}


static
int setting_set (lua_State * L) {
    NSString* key = NS_String(luaL_checkstring(L, 1));
    id value = nil;
    switch (lua_type(L, 2)) {
        case LUA_TSTRING:
            value = NS_String(luaL_checkstring(L, 2));
            break;
        case LUA_TNUMBER:
            value = [NSNumber numberWithDouble:luaL_checknumber(L, 2)];
            break;
        case LUA_TBOOLEAN:
            value = [NSNumber numberWithBool:lua_toboolean(L, 2)];
            break;
        default:
            luaL_error(L, "未知类型");
            return 0;
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:@"./settings.plist"];
    if (!dict) dict = [NSMutableDictionary dictionary]; /* 无ui 保存 */
    
    NSMutableDictionary* Settings = [dict objectForKey:@"Settings"];
    if (!Settings) {
        Settings = [NSMutableDictionary dictionary];
        [dict setObject:Settings forKey:@"Settings"];
    }
    
    [Settings setObject:value forKey:key];
    [dict writeToFile:@"./settings.plist" atomically:YES];
    return 0;
}


static
int setting_clear (lua_State * L) {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:@"./settings.plist"];
    if (!dict)
        return 0;
    
    NSMutableDictionary* Settings = [dict objectForKey:@"Settings"];
    if (!Settings)
        return 0;
    
    [dict removeObjectForKey:@"Settings"];
    [dict writeToFile:@"./settings.plist" atomically:YES];
    
    return 0;
}


static struct luaL_Reg setting_fun[] = {
    { "get", setting_get},
    { "set", setting_set},
    { "clear", setting_clear},
    { NULL , NULL }
};


int luaopen_setting (lua_State* L) {
    luaL_newlib(L, setting_fun);
    lua_setglobal(L, "Setting");
    return 0;
}
