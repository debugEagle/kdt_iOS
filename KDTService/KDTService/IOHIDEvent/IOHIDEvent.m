//
//  ATMessage.c
//  ATEngine
//
//  Created by wd on 15-3-8.
//
//

#import <UIKit/UIKit.h>
#import "IOHIDEvent.h"
#import "HPSpringBoardService.h"

extern UInt64 IOHIDEventGetSenderID(IOHIDEventRef event);

void IOHIDEventCallBack (void* target, void* refcon, IOHIDEventQueueRef queue, IOHIDEventRef event);

static IOHIDEventCtx* messageModule = nil;


void IOHIDEvent_init(void){
    if (!messageModule) {
        IOHIDEventCtx* ret = malloc(sizeof(IOHIDEventCtx));
        if (!ret) {
            NSLog(@"messageModule_init error,new\n");
            exit(1);
        }
        memset(ret, 0, sizeof(IOHIDEventCtx));
        IOHIDEventSystemClientRef client = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
        NSLog(@"client:%p",client);
        ret->client = client;
        messageModule = ret;
        NSLog(@"event engine is done\n");
    }
}

void IOHIDEvent_close(void){
    if (messageModule) {
        free(messageModule);
        messageModule = nil;
    }
}

void IOHIDEvent_startListen(void){
    NSLog(@"IOHIDEvent_startListen");
    IOHIDEventSystemClientScheduleWithRunLoop(messageModule->client, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    IOHIDEventSystemClientRegisterEventCallback(messageModule->client, &IOHIDEventCallBack, NULL, NULL);
}

void IOHIDEvent_stopListen(void){
    NSLog(@"IOHIDEvent_stopListen");
    IOHIDEventSystemClientUnregisterEventCallback(messageModule->client, &IOHIDEventCallBack,NULL,NULL);
    IOHIDEventSystemClientUnscheduleWithRunLoop(messageModule->client, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
}

void IOHIDEventCallBack (void* target, void* refcon, IOHIDEventQueueRef queue, IOHIDEventRef event) {
    IOHIDEventRef childEvent;
    CFArrayRef childEventArray;
    IOHIDEventType superType,childEventType;
    UInt64 senderID;
    
    int keyusagePage,keyUsage,keyIsDown,keyReapeat;
    int mainX,mainY,mainZ,mainType,mainIndex,mainIdentity,mainEventMast,mainRange,mainTouch;
    int childX,childY,childIndex,childIdentity,childTouch;
    int accelerometerX,accelerometerY,accelerometerZ;
    superType = IOHIDEventGetType(event);
    //WDLog("IOHIDEventGetType:%d", superType);
    senderID = IOHIDEventGetSenderID(event);
    switch (superType) {
        case kIOHIDEventTypeAccelerometer:
            accelerometerX = IOHIDEventGetFloatValue(event,kIOHIDEventFieldAccelerometerX);
            accelerometerY = IOHIDEventGetFloatValue(event,kIOHIDEventFieldAccelerometerY);
            accelerometerZ = IOHIDEventGetFloatValue(event,kIOHIDEventFieldAccelerometerZ);
            //NSLog(@"Accelerometer:%d,%d,%d",accelerometerX,accelerometerY,accelerometerZ);
            break;
        case kIOHIDEventTypeKeyboard:
            keyusagePage = IOHIDEventGetIntegerValue(event,kIOHIDEventFieldKeyboardUsagePage);
            keyUsage = IOHIDEventGetIntegerValue(event,kIOHIDEventFieldKeyboardUsage);
            keyIsDown = IOHIDEventGetIntegerValue(event,kIOHIDEventFieldKeyboardDown);
            keyReapeat = IOHIDEventGetIntegerValue(event,kIOHIDEventFieldKeyboardRepeat);
            NSLog(@"%llx: %d %@ %d\n",senderID,keyUsage,(keyIsDown)?@"按下":@"抬起", keyusagePage);
            HPSpringBoardService* sbs = [HPSpringBoardService sharedInstance];
            if (keyUsage == kVolumeDownKey && !keyIsDown) {
                NSLog(@"%p", sbs.proxy);
                [(id)sbs.proxy menuVisibleChange];
            }
            if (keyUsage == kVolumeUpKey && !keyIsDown) {
                NSLog(@"%p", sbs.proxy);
                [(id)sbs.proxy menuVisibleChange];
            }
            //048 电源键
            //233 音量＋
            //234 音量－
            //046 静音键
            //064 主键
            //keyusagePage = 12
            break;
        case kIOHIDEventTypeDigitizer:
            //super
            mainX = IOHIDEventGetFloatValue(event,kIOHIDEventFieldDigitizerX) * messageModule->width;
            mainY = IOHIDEventGetFloatValue(event,kIOHIDEventFieldDigitizerY) * messageModule->height;
            mainZ = IOHIDEventGetFloatValue(event,kIOHIDEventFieldDigitizerZ);
            
            mainType = IOHIDEventGetFloatValue(event,kIOHIDEventFieldDigitizerType);
            mainIndex = IOHIDEventGetFloatValue(event,kIOHIDEventFieldDigitizerIndex);
            mainIdentity = IOHIDEventGetFloatValue(event,kIOHIDEventFieldDigitizerIdentity);
            
            mainEventMast = IOHIDEventGetIntegerValue(event,kIOHIDEventFieldDigitizerEventMask);
            mainRange = IOHIDEventGetIntegerValue(event,kIOHIDEventFieldDigitizerRange);
            mainTouch = IOHIDEventGetIntegerValue(event,kIOHIDEventFieldDigitizerTouch);
            
            //            NSLog(@"%llx:(%d,%d,%d):(%04x,%04x,%04x):(%d,%d,%d)\n",
            //                 senderID,mainX,mainY,mainZ,mainEventMast,mainRange,mainTouch,mainType,mainIndex,mainIdentity);
            
            //child
            childEventArray = IOHIDEventGetChildren(event);
            if (childEventArray) {
                for (CFIndex i = CFArrayGetCount(childEventArray) - 1; i >= 0; i--) {
                    childEvent = (IOHIDEventRef)CFArrayGetValueAtIndex(childEventArray,i);
                    childEventType = IOHIDEventGetType(childEvent);
                    childX = IOHIDEventGetFloatValue(childEvent,kIOHIDEventFieldDigitizerX) * messageModule->width;
                    childY = IOHIDEventGetFloatValue(childEvent,kIOHIDEventFieldDigitizerY) * messageModule->height;
                    childIndex = IOHIDEventGetFloatValue(childEvent,kIOHIDEventFieldDigitizerIndex);
                    childIdentity = IOHIDEventGetFloatValue(childEvent,kIOHIDEventFieldDigitizerIdentity);
                    childTouch = IOHIDEventGetIntegerValue(childEvent,kIOHIDEventFieldDigitizerTouch);
                }
                //                NSLog(@"    child:[%d,%d]:[%d-%d-%d]\n",
                //                      childX,childY,childIndex,childIdentity,childTouch);
            }
            break;
        default:
            break;
    }
}
