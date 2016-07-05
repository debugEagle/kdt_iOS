// lua.hpp
// Lua header files for C++
// <<extern "C">> not supplied automatically because Lua also compiles as C++


#ifdef __cplusplus
extern "C" {
#endif
    
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "ldebug.h"
    
#ifdef __cplusplus
}
#endif


#define LUA_USE_MACOSX 1

