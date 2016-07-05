//
//  conf.h
//  jiuyin
//
//  Created by wd on 15-11-22.
//
//

#ifndef jiuyin_conf_h
#define jiuyin_conf_h

#include <CoreFoundation/CoreFoundation.h>
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


#define BTGobaloldColor kUIColorFromRGB(0xec5252)
#define BTBackgroundColor kUIColorFromRGB(0xd3d3d3)
#define BTBatteryColor kUIColorFromRGB(0x526eec)
#define BTGobalRedColor kUIColorFromRGB(0x4b7eeb)
#define BTColor(r,g,b) [UIColor  colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define kUIColorFromRGB(rgbValue) [UIColor                \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0           \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)

#define NS_String(cstr) [NSString stringWithUTF8String:cstr]
#define NS_Int(int) [NSNumber numberWithInt:int]
#define NS_Float(float) [NSNumber numberWithFloat:float]

#define STL2NS_string(stl_str)\
[[[NSString alloc] initWithBytes:stl_str length:wcslen(stl_str)*sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding] autorelease]

#endif
