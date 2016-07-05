//
//  ocrLua.h
//  iOSOcrTest
//
//  Created by wd on 15-8-26.
//
//

#ifndef iOSOcrTest_ocrLua_h
#define iOSOcrTest_ocrLua_h

#ifdef __cplusplus
extern "C" {
#endif
    
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
    
#include "OcrDict.h"
#include "OcrDo.h"
    
    // sum, str = dm.Ocr(x1, y1, x2, y2, color, sim, dir)
    // x1,y1,x2,y2:用户自定义坐标系,不包括x2,y2点
    // color: 所要查找字的颜色，参数 为字符串, 举例: “f0e8e0-202020|e4d9c9-202020” |分割多个颜色，f0e8e0-202020
    // f0e8e0为主色, 202020为允许颜色上下范围浮动的值，分别为三个分量 R20 G20 B20   最大支持10个颜色
    // dir:查找方向,不填写,则默认与初始化方向相同。
    // 返回值:sum:
    // sum:找到字符个数.
    // str:为所找到的字符串,注意,使用前要设定所使用的字典
    // 此函数适合在背景固定的场景使用,例如:读取金币,坐标,等级,地图名字
    int lua_OCR(lua_State *L);
    
    
    // x, y = dm.Ocr(x1, y1, x2, y2, str,color, sim, dir)
    // x1,y1,x2,y2:用户自定义坐标系,不包括x2,y2点
    // str:所查找的文字
    // color: 所要查找字的颜色，参数 为字符串, 举例: “f0e8e0-202020|e4d9c9-202020” |分割多个颜色，f0e8e0-202020
    // f0e8e0为主色, 202020为允许颜色上下范围浮动的值，分别为三个分量 R20 G20 B20   最大支持10个颜色
    // dir:查找方向,不填写,则默认与初始化方向相同。
    // 返回值: 使用前确认所找字在字库里
    // x:找到字符坐标x,未找到返回-1
    // y:找到字符坐标y,未找到返回-1
    // 此函数适合在背景固定的场景使用,若在大地图找怪 推荐用Ex
    int lua_findStr(lua_State *L);
    
    
//    //宽松匹配模式
//    int lua_OCREx(lua_State *L);
//    int lua_findStrEx(lua_State *L);
    
    // 初始化字典,dm.SetDict(index,table)
    //  index:字典序号,table:字典表
    //  返回值:成功返回0
    //  -1:table 不是一个表结构
    //  -2:字典index 不是一个有效的值
    //  -3:该字典已经设置过了
    //  推荐 数字 和 汉字分开存放
    //  最大支持16个字典
    int lua_initDict(lua_State *L);
    
    //  选择字典,dm.UseDict(index)
    //  index:字典序号
    //  返回值:成功返回0
    //  -2:字典index 不是一个有效的值
    int lua_useDict(lua_State *L);
    
    
    // 删除字典,dm.DelDict(index)
    //  index:字典序号
    //  返回值:成功返回0
    //  -2:字典index 不是一个有效的值
    int lua_delDict(lua_State *L);
    
    static struct luaL_Reg OCR_fun[] = {
        { "Ocr" ,       lua_OCR      },
        //{ "OcrEx" ,     lua_OCREx    },
        { "FindStr" ,   lua_findStr  },
        //{ "FindStrEx",  lua_findStrEx},
        { "SetDict" ,   lua_initDict },
        { "UseDict" ,   lua_useDict  },
        { "DelDict" ,   lua_delDict  },
        { NULL , NULL }
    };
        
    int luaopen_dm (lua_State* L);
    
#ifdef __cplusplus
}
#endif


#endif
