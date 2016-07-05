//
//  Touch.h
//  KDTPower
//
//  Created by wd on 16-3-14.
//
//

#ifndef __KDTPower__Touch__
#define __KDTPower__Touch__

#include <stdio.h>

#include "conf.h"
#include "Com.h"
#import <mach/mach_time.h>
#import <IOKit/hid/IOHIDEventSystem.h>
#import <IOKit/hid/IOHIDEvent.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    extern
    void IOHIDEventSystemClientDispatchEvent(IOHIDEventSystemClientRef client, IOHIDEventRef event);
    extern
    void IOHIDEventSetSenderID(IOHIDEventRef event, UInt64 opt);

#ifdef __cplusplus
}
#endif

#define kIOHIDTransducerTypeHand 3

namespace Touch {
    void init();
    void touch(int finger, int opt, int x, int y);
    void key(int type, int opt);
    void setRotation(int r);
}


#endif /* defined(__KDTPower__Touch__) */
