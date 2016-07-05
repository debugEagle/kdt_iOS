//
//  ATMessage.h
//  arhp 监听音量键的类
//
//  Created by wd on 15-3-8.
//
//

#ifndef ATEngine_ATMessage_h
#define ATEngine_ATMessage_h

#import <IOKit/hid/IOHIDEventSystem.h>
#import <IOKit/hid/IOHIDEvent.h>
#import <Foundation/Foundation.h>

enum{
    kUsagePage = 12,
    kNoVolumeKey = 46,
    kPowerKey = 48,
    kMainKey = 64,
    kVolumeUpKey = 233,
    kVolumeDownKey
};

typedef struct _IOHIDEventCtx{
    IOHIDEventSystemClientRef   client;
    uint32_t        width;
    uint32_t        height;
}IOHIDEventCtx;

void IOHIDEvent_init(void);
void IOHIDEvent_close(void);
void IOHIDEvent_startListen(void);
void IOHIDEvent_stopListen(void);

#endif
