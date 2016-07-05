//
//  Touch.cpp
//  KDTPower
//
//  Created by wd on 16-3-14.
//
//

#include "Touch.h"
#include "Com.h"
#import <UIKit/UIKit.h>


#pragma mark- NSTouch

@interface NSTouch: NSObject

@property (nonatomic, assign) int finger;
@property (nonatomic, assign) int opt;
@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;

@end

@implementation NSTouch

+(id) touchWithFinger:(int) finger posX:(int) x posY:(int) y operate:(int) opt {
    NSTouch* touch = [[NSTouch alloc] init];
    touch.finger = finger;
    touch.opt = opt;
    touch.x = x;
    touch.y = y;
    return [touch autorelease];
}

@end


typedef struct {
    Com::env        env;
    id              touchs;
    void*           client;
} TouchCtx;

static TouchCtx _ctx;


#pragma mark- Touch

void Touch::init() {
    NSLog(@"Touch::init");
    _ctx.touchs = [[NSMutableDictionary alloc] init];
    _ctx.client = IOHIDEventSystemClientCreate(kCFAllocatorDefault);;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float scale = [UIScreen mainScreen].scale;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _ctx.env.width = screenSize.width * scale;
        _ctx.env.height = screenSize.height * scale;
    } else {
        _ctx.env.width = screenSize.height * scale;
        _ctx.env.height = screenSize.width * scale;
    }
}


static
void _send(IOHIDEventRef event){
    if (!event) return;
    IOHIDEventSystemClientDispatchEvent((IOHIDEventSystemClientRef)_ctx.client, event);
    CFRelease(event);
}


static
IOHIDEventRef _createTouchEvent(void)
{
    NSInteger touchCount = [[_ctx.touchs allKeys] count];
    if (!touchCount) return nil;
    
    uint64_t abTime = mach_absolute_time();
    AbsoluteTime timeStamp = *(AbsoluteTime *) &abTime;
    IOHIDEventRef handEvent = IOHIDEventCreateDigitizerEvent(
                                                             kCFAllocatorDefault,
                                                             timeStamp,
                                                             kIOHIDTransducerTypeHand,
                                                             0, 1, 0x3, 0, 0, 0, 0, 0, 0, 1, 1, 0
                                                             );
    IOHIDEventSetIntegerValueWithOptions(handEvent, kIOHIDEventFieldDigitizerDisplayIntegrated, 1, 0xF0000000);
    IOHIDEventSetIntegerValueWithOptions(handEvent, kIOHIDEventTypeTranslation, 1, 0xF0000000);
    
    //IOHIDEventSetSenderID(handEvent, 0xDEFACEDBEEFFECE5);
    //IOHIDEventSetSenderID(handEvent, 0x1000002e8);
    //IOHIDEventSetSenderID(handEvent, 0x000000010000027F);
    /* assistivetouchd id */
    IOHIDEventSetSenderID(handEvent, 0x8000000817319372);
    
    int i = 0;
    int width = _ctx.env.width;
    int height = _ctx.env.height;
    
    int handEventMask = 0;
    int handEventTouch = 0;
    
    for (NSNumber* index in [_ctx.touchs allKeys]) {
        NSTouch* touch = [_ctx.touchs objectForKey:index];
        int touchType = touch.opt;
        int eventType = (touchType == TOUCH_MOVE) ? kIOHIDDigitizerEventPosition : (kIOHIDDigitizerEventRange | kIOHIDDigitizerEventTouch);
        int isDown = (touchType == TOUCH_UP) ? 0 : 1;
        
        handEventTouch |= isDown;
        
        if (touchType == TOUCH_MOVE || touchType == TOUCH_UP)
            handEventMask |= kIOHIDDigitizerEventPosition;
        else
            handEventMask |= (kIOHIDDigitizerEventRange | kIOHIDDigitizerEventTouch | kIOHIDDigitizerEventIdentity);
        
        float x = touch.x * 1.0f;
        float y = touch.y * 1.0f;
        float rx = x / width;
        float ry = y / height ;
        IOHIDEventRef fingerEvent = IOHIDEventCreateDigitizerFingerEventWithQuality(
                                                                                    kCFAllocatorDefault,
                                                                                    timeStamp,
                                                                                    [index intValue],
                                                                                    i + 2, eventType, rx, ry,
                                                                                    0, 0, 0, 0, 0, 0, 0, 0,
                                                                                    isDown, isDown, 0
                                                                                    );
        IOHIDEventAppendEvent(handEvent, fingerEvent);
        if (touchType == TOUCH_UP)
            [_ctx.touchs removeObjectForKey:index];
        else
            i++;
    }
    
    IOHIDEventSetIntegerValueWithOptions(handEvent, kIOHIDEventFieldDigitizerEventMask, handEventMask, 0xF0000000);
    IOHIDEventSetIntegerValueWithOptions(handEvent, kIOHIDEventFieldDigitizerRange, handEventTouch, 0xF0000000);
    IOHIDEventSetIntegerValueWithOptions(handEvent, kIOHIDEventFieldDigitizerTouch, handEventTouch, 0xF0000000);
    
    return handEvent;
}


void Touch::touch(int finger, int opt, int x, int y) {
    /* 转为标准坐标系 */
    Com::transform(&_ctx, &x, &y, IPHONE_DIR_STD);
    
    NSNumber* NSfinger = NS_Int(finger);
    NSTouch* touch =[_ctx.touchs objectForKey:NSfinger];
    if (!touch) {
        touch = [[[NSTouch alloc] init] autorelease];
        [_ctx.touchs setObject:touch forKey:NSfinger];
    }
    touch.finger = finger;
    touch.opt = opt;
    touch.x = x;
    touch.y = y;
    IOHIDEventRef event = _createTouchEvent();
    _send(event);
}


void Touch::key(int key, int opt) {
    uint64_t abTime = mach_absolute_time();
    AbsoluteTime timeStamp = *(AbsoluteTime *) &abTime;
    IOHIDEventRef event = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault, timeStamp, 12, key, opt, 0);
    //IOHIDEventSetSenderID(event, 0x100000190);
    //IOHIDEventSetSenderID(event, 0x1000002e8);
    IOHIDEventSetSenderID(event, 0x8000000817319372);
    _send(event);
}


void Touch::setRotation(int r) {
    _ctx.env.rotation = r;
}






