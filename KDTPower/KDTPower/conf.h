//
//  conf.h
//  jiuyin
//
//  Created by wd on 15-11-22.
//
//

#ifndef conf_h
#define conf_h

#include <CoreFoundation/CoreFoundation.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <stdio.h>

#include <unistd.h>
#include <sys/sysctl.h>
#include <stdlib.h>

#include <wchar.h>
#include <string.h>
#include <stdlib.h>



typedef int (*hook_imp)(id, SEL, id, id);

#define r(x) (*(int*)(x))

#define fi(x) (reinterpret_cast<int&>(x))
#define f(x) (reinterpret_cast<float&>(x))
#define i(x) (reinterpret_cast<int>(x))
#define v(x) (reinterpret_cast<void*>(x))

#define NS_String(cstr) [NSString stringWithUTF8String:cstr]
#define NS_Int(int) [NSNumber numberWithInt:int]

#define STL2NS_string(stl_str)\
[[[NSString alloc] initWithBytes:stl_str length:wcslen(stl_str)*sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding] autorelease]


//NS_RETURNS_INNER_POINTER 返回内部指针
NS_INLINE 
wchar_t* NS2STL_string(NSString* ns_str) {
    NSMutableData* data = [NSMutableData dataWithData:
                           [ns_str dataUsingEncoding:NSUTF32LittleEndianStringEncoding allowLossyConversion:YES]];
    wchar_t end = 0;
    [data appendBytes:&end length:sizeof(wchar_t)];
    return (wchar_t*)[data bytes];
}


#define StatusMask(type) (1<<type)
#define StatusIn(mask,type)  mask & StatusMask(type)
#define StatusSet1(mask,type)  mask |=  StatusMask(type)
#define StatusSet0(mask,type)  mask &= ~StatusMask(type)

#define GetR(c) ((c & 0x00ff0000)>>16)
#define GetG(c) ((c & 0x0000ff00)>>8)
#define GetB(c)  (c & 0x000000ff)

#ifdef OUTLOG
#define LOG(...) NSLog(__VA_ARGS__);
#define LOG_METHOD NSLog(@"%s", __func__);
#else
#define LOG(...)
#define LOG_METHOD
#endif

enum{
    kUsagePage = 12,
    kNoVolumeKey = 46,
    kPowerKey = 48,
    kMainKey = 64,
    kVolumeUpKey = 233,
    kVolumeDownKey
};

#define LOCAL_MACH_PORT_NAME_ORDER  "com.TestCode.tool"

#endif
