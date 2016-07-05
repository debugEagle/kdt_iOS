//
//  KDTApi.cpp
//  KDTPower
//
//  Created by wd on 16-3-26.
//
//

#include "KDTApi.h"
#include "conf.h"
#import <UIKit/UIKit.h>

#include "sysLua.h"
#include "screenLua.h"
#include "touchLua.h"
#include "keyLua.h"
#include "appLua.h"
#include "OcrLua.h"
#include "httpLua.h"
#include "threadLua.h"
#include "settingLua.h"


int KDTApiOpen(lua_State *L) {
    luaopen_sys(L);
    luaopen_screen(L);
    luaopen_touch(L);
    luaopen_key(L);
    luaopen_app(L);
    luaopen_dm(L);
    luaopen_http(L);
    luaopen_thread(L);
    luaopen_setting(L);
    return 0;
}










