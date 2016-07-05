//
//  KDTApi.h
//  KDTPower
//
//  Created by wd on 16-3-26.
//
//

#ifndef __KDTPower__KDTApi__
#define __KDTPower__KDTApi__

#include <stdio.h>
#include "3rd/lua/lua.hpp"


#ifdef __cplusplus

extern "C" {
#endif
    
    int KDTApiOpen(lua_State *L);
    
#ifdef __cplusplus
}
#endif


#endif /* defined(__KDTPower__KDTApi__) */
