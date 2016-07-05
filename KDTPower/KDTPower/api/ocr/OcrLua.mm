//
//  ocrLua.m
//  iOSOcrTest
//
//  Created by wd on 15-8-26.
//
//

#import "OcrLua.h"
#import "Graphics.h"


//参数越界检查
static
void checkOverFlow(lua_State *L, MapCtx* ctx, int x1, int y1, int x2, int y2) {
    
    printf("%d:(%d,%d,%d,%d)\n",ctx->dir, x1, y1, x2, y2);
    
    switch (ctx->dir) {
        case IPHONE_DIR_D:
        case IPHONE_DIR_U:
            if   ( (x1 < 0 || y1 < 0)
                  ||(x1 > ctx->width || y1 > ctx->height)
                  ||(x2 < 0 || y2 < 0)
                  ||(x2 > ctx->width || y2 > ctx->height)
                  ||(x1 >= x2 || y1 >= y2) )                          //不包括x2,y2所以不能等于
            {
                luaL_error(L, "ocr参数错误,请检查一下参数是否越界");
            }
            break;
        case IPHONE_DIR_R:
        case IPHONE_DIR_L:
            if   ( (x1 < 0 || y1 < 0)
                  ||(x1 > ctx->height || y1 > ctx->width)
                  ||(x2 < 0 || y2 < 0)
                  ||(x2 > ctx->height || y2 > ctx->width)
                  ||(x1 >= x2 || y1 >= y2) )
            {
                luaL_error(L, "ocr参数错误,请检查一下参数是否越界");
            }
            break;
        default:
            luaL_error(L, "无效的ocr方向参数, 应为0-3");
    }
    
}


//首先将用户坐标系转化为标准坐标系,然后再转换为文字方向的坐标系.
static
void fixSize(MapCtx* ctx, int x1, int y1, int x2, int y2,
             int* x, int* y, int* width, int* height, int word_dir)
{
    pointUserToStd(ctx->dir, ctx->width, ctx->height, &x1, &y1);
    pointUserToStd(ctx->dir, ctx->width, ctx->height, &x2, &y2);
    
    pointStdToUser(word_dir, ctx->width, ctx->height, &x1, &y1);
    pointStdToUser(word_dir, ctx->width, ctx->height, &x2, &y2);
    
    *x = x1 < x2 ? x1 : x2;
    *y = y1 < y2 ? y1 : y2;
    
    *width = abs(x2 - x1) + 1;               //宽度 + 1
    *height = abs(y2 - y1) + 1;
    printf("(%d,%d,%d,%d)\n",*x, *x, *width, *height);
    
}


int lua_OCR(lua_State *L){
    
    @autoreleasepool {
        int x1 = luaL_checkinteger(L, 1);
        int y1 = luaL_checkinteger(L, 2);
        int x2 = luaL_checkinteger(L, 3);
        int y2 = luaL_checkinteger(L, 4);
        const char* c_olor = luaL_checkstring(L, 5);
        double sim = luaL_checknumber(L, 6);
        
        bool dir_fix = false;
        int word_dir = 0;
        if (lua_gettop(L) == 7){
            word_dir = luaL_checkinteger(L, 7);
            dir_fix = true;
        }
        else
            word_dir = ctx.dir;
        
        checkOverFlow(L, &ctx, x1, y1, x2, y2);
        NSString* color = [NSString stringWithCString:c_olor encoding:NSUTF8StringEncoding];
        DictWord* dict = (DictWord*)dictBundle.dicts[dictBundle.curt_dict].next;
        
        int x,y,width,height;
        x2--,y2--;                      //不包括x2,y2
        
        fixSize(&ctx, x1, y1, x2, y2, &x, &y, &width, &height, word_dir);
        
        int retX = -1;
        int retY = -1;
        int sum = 0;
        UInt32 type = 0;
        type = SET_SEARCH_OCR(type);    //ocr
        
        /* 刷新屏幕缓冲区 */
        Graphics::randerDisplay();
        
        NSString* ret = findStr(&ctx, type, x, y, width, height, color, sim, word_dir, dict, &retX, &retY, &sum);
        if (sum != 0 && dir_fix) {
            pointUserToStd(word_dir, ctx.width, ctx.height, &retX, &retY);
            pointStdToUser(ctx.dir, ctx.width, ctx.height, &retX, &retY);
            printf("ret %d,%d\n", retX,retY);
        }
        
        lua_pushstring(L, [ret UTF8String]);
        lua_pushinteger(L, sum) ;
        
        [ret release];
        
        return 2;
    }
    
}

//int lua_OCREx(lua_State *L){
//    
//    @autoreleasepool {
//        int x = luaL_checkinteger(L, 1);
//        int y = luaL_checkinteger(L, 2);
//        int width = luaL_checkinteger(L, 3);
//        int height = luaL_checkinteger(L, 4);
//        const char* c_olor = luaL_checkstring(L, 5);
//        double sim = luaL_checknumber(L, 6);
//        int dir = luaL_checkinteger(L, 7);
//        
//        checkOverFlow(L, &ctx, x, y, width, height);
//        NSString* color = [NSString stringWithCString:c_olor encoding:NSUTF8StringEncoding];
//        
//        DictWord* dict = dictBundle.dicts[dictBundle.curt_dict].next;
//        
//        int retX = -1;
//        int retY = -1;
//        int sum = 0;
//        UInt32 type = 0;
//        type = SET_SEARCH_OCR(type);    // ocr模式
//        type = SET_SEARCH_FAST(type);   // 宽松模式
//        
//        NSString* ret = findStr(&ctx, type, x, y, width, height, color, sim, dir, dict, &retX, &retY, &sum);
//        lua_pushstring(L, [ret UTF8String]);
//        lua_pushinteger(L, sum) ;
//        
//        [ret release];
//        
//        return 2;
//    }
//    
//}


int lua_initDict(lua_State *L) {
    @autoreleasepool {
        int index = luaL_checkinteger(L, 1);
        
        if (index < 0 || index >(DICT_MAX - 1)) {            //index 不是一个有效的字库序号
            lua_pushinteger(L, -1);                          //dict不是一个有效的表
            return 1;
        }
        
        if (!lua_istable(L, 2)) {
            lua_pushinteger(L, -2);                          //dict不是一个有效的表
            return 1;
        }
        
        NSMutableSet* set = [[[NSMutableSet alloc]init] autorelease];
        
        lua_pushnil(L);
        while (lua_next(L, 2)) {
            const char* v = luaL_checkstring(L, -1);
            NSString* value = [NSString stringWithCString:v encoding:NSUTF8StringEncoding];
            [set addObject:value];
            lua_pop(L, 1);
        }
        int ret = initDict(&dictBundle, index, set);
        lua_pushinteger(L, ret);
        return 1;
    }
}


int lua_useDict(lua_State *L) {
    printf("useDict\n");
    int index = luaL_checkinteger(L, 1);
    int ret = useDict(&dictBundle, index);
    lua_pushinteger(L, ret);
    return 1;
}


int lua_delDict(lua_State *L) {
    int index = luaL_checkinteger(L, 1);
    int ret = delDict(&dictBundle, index);
    lua_pushinteger(L, ret);
    return 1;
}


int lua_findStr(lua_State *L){
    @autoreleasepool {
        int x1 = luaL_checkinteger(L, 1);
        int y1 = luaL_checkinteger(L, 2);
        int x2 = luaL_checkinteger(L, 3);
        int y2 = luaL_checkinteger(L, 4);
        const char* c_wort = luaL_checkstring(L, 5);
        const char* c_olor = luaL_checkstring(L, 6);
        double sim = luaL_checknumber(L, 7);
        
        bool dir_fix = false;
        int word_dir = 0;
        if (lua_gettop(L) == 8){
            word_dir = luaL_checkinteger(L, 8);
            dir_fix = true;
        }
        else
            word_dir = ctx.dir;
        
        checkOverFlow(L, &ctx, x1, y1, x2, y2);
        NSString* color = [NSString stringWithCString:c_olor encoding:NSUTF8StringEncoding];
        NSString* word = [NSString stringWithCString:c_wort encoding:NSUTF8StringEncoding];
        DictWord* dict = findWord(&dictBundle, word);
        
        int x,y,width,height;
        x2--,y2--;                      //不包括x2,y2
        
        fixSize(&ctx, x1, y1, x2, y2, &x, &y, &width, &height, word_dir);
        
        /* 刷新屏幕缓冲区 */
        Graphics::randerDisplay();
        
        int retX = -1;
        int retY = -1;
        int sum = 0;
        UInt32 type = 0;        //find,严格匹配模式
        if (dict != NULL) {
            NSString* ret = findStr(&ctx, type, x, y, width, height, color, sim, word_dir, dict, &retX, &retY, &sum);
            [ret release];
            removeWord(dict);
            
            if (sum != 0 && dir_fix) {
                pointUserToStd(word_dir, ctx.width, ctx.height, &retX, &retY);
                pointStdToUser(ctx.dir, ctx.width, ctx.height, &retX, &retY);
                printf("ret %d,%d\n", retX,retY);
            }
        }
        lua_pushinteger(L, retX);
        lua_pushinteger(L, retY);
        return 2;
    }
}

//int lua_findStrEx(lua_State *L){
//    @autoreleasepool {
//        int x1 = luaL_checkinteger(L, 1);
//        int y1 = luaL_checkinteger(L, 2);
//        int x2 = luaL_checkinteger(L, 3);
//        int y2 = luaL_checkinteger(L, 4);
//        const char* c_wort = luaL_checkstring(L, 5);
//        const char* c_olor = luaL_checkstring(L, 6);
//        double sim = luaL_checknumber(L, 7);
//        
//        int word_dir = 0;
//        if (lua_gettop(L) == 8)
//            word_dir = luaL_checkinteger(L, 8);
//        else
//            word_dir = ctx.dir;
//        
//        checkOverFlow(L, &ctx, x1, y1, x2, y2);
//        NSString* color = [NSString stringWithCString:c_olor encoding:NSUTF8StringEncoding];
//        NSString* word = [NSString stringWithCString:c_wort encoding:NSUTF8StringEncoding];
//        DictWord* dict = findWord(&dictBundle, word);
//        
//        int x,y,width,height;
//        x2--,y2--;                  //不包括x2,y2
//        fixSize(&ctx, x1, y1, x2, y2, &x, &y, &width, &height, word_dir);
//        
//        int retX = -1;
//        int retY = -1;
//        int sum = 0;
//        UInt32 type = 0;                // find模式
//        type = SET_SEARCH_FAST(type);   // 宽松模式
//        
//        if (dict != NULL) {
//            NSString* ret = findStr(&ctx, type, x1, y1, x2, y2, color, sim, word_dir, dict, &retX, &retY, &sum);
//            [ret release];
//            removeWord(dict);
//        }
//        lua_pushinteger(L, retX);
//        lua_pushinteger(L, retY);
//        return 2;
//    }
//}

int luaopen_dm (lua_State* L){
    luaL_newlib(L, OCR_fun);
    lua_setglobal(L, "Dm");
    return 0;
}

