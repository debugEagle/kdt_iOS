//
//  CM.cpp
//  KDTPower
//
//  Created by wd on 16-3-14.
//
//

#include "Com.h"

void Com::init() {

}



void Com::transform (void* ctx,  int* outx, int* outy, int opt) {
    int x = *outx;
    int y = *outy;
    
    Com::env* env = (Com::env*)ctx;
    
    int width = env->width;
    int height = env->height;
    
    switch (env->rotation) {
        case IPHONE_DIR_D:
            break;
        case IPHONE_DIR_R:
            if (opt == IPHONE_DIR_STD) {
                *outx = width - y - 1;
                *outy = x;
            }
            if (opt == IPHONE_DIR_USER) {
                *outx = y;
                *outy = width - x - 1;
            }
            break;
        case IPHONE_DIR_L:
            if (opt == IPHONE_DIR_STD) {
                *outx = y;
                *outy = height - x - 1;
            }
            if (opt == IPHONE_DIR_USER) {
                *outx = height - y - 1;
                *outy = x;
            }
            break;
        case IPHONE_DIR_U:
            *outx = width - x - 1;
            *outy = height - y - 1;
            break;
        default:
            break;
    }
}



bool Com::inState(UInt32 stuts, UInt32 pos) {
    return (stuts>>pos) & 1;
}

void Com::setState(UInt32 *pstuts, UInt32 pos, UInt32 value) {
    UInt32 stuts = *pstuts;
    (value) ? ((stuts) |= (1 << pos)) : ((stuts) &= ~(1 << pos));
    *pstuts = stuts;
}













