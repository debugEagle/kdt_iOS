//
//  CM.h
//  KDTPower
//
//  Created by wd on 16-3-24.
//
//

#ifndef __KDTPower__Com__
#define __KDTPower__Com__

#include <stdio.h>
#include "conf.h"

#define IPHONE_DIR_D 0
#define IPHONE_DIR_R 1
#define IPHONE_DIR_L 2
#define IPHONE_DIR_U 3

#define IPHONE_DIR_STD 1        //标准坐标系
#define IPHONE_DIR_USER 0       //自定义坐标系

#define TOUCH_MOVE  0
#define TOUCH_DOWN  1
#define TOUCH_UP    2

namespace Com {
    
    typedef struct {
        int             rotation;
        UInt32         width;
        UInt32         height;
    } env;
    
    void init();
    void transform (void* ctx,  int* outx, int* outy, int opt);
    bool inState(UInt32 stuts, UInt32 pos);
    void setState(UInt32 *stuts, UInt32 pos, UInt32 value);
}

#endif /* defined(__KDTPower__Com__) */

