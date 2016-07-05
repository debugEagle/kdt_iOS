//
//  Graphics.h
//  KDTPower
//
//  Created by wd on 16-3-14.
//
//

#ifndef __KDTPower__Graphics__
#define __KDTPower__Graphics__

#include <stdio.h>
#import <IOSurface/IOSurface.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    extern void CARenderServerRenderDisplay(kern_return_t a, CFStringRef b, IOSurfaceRef surface, int x, int y);
    
#ifdef __cplusplus
}
#endif

namespace Graphics {
    
    enum {
        kGraphicsRanderlock
    };
    
    void init();
    void setRotation(int r);
    bool keepStatus();
    bool randerDisplay();
    void keepScreen(bool b);
    void getScreenSize(int* width, int* height);
    UInt32 getColor(int x, int y);
    NSString* findColorEx(int fistColor, NSString* otherPoint, int x1, int y1, int x2, int y2, double sim, int dir, int* retX, int* retY);
}

#endif /* defined(__KDTPower__Graphics__) */
