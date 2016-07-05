#line 1 "/Users/wd/project/KDT/KDTWindow/KDTWindow/KDTWindow.xm"


#import "KDTWindow.h"
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

#include <logos/logos.h>
#include <substrate.h>
@class SpringBoard; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(SpringBoard*, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(SpringBoard*, SEL, id); 

#line 8 "/Users/wd/project/KDT/KDTWindow/KDTWindow/KDTWindow.xm"



static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(SpringBoard* self, SEL _cmd, id application) {
    @autoreleasepool {
        _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application);
        KDTWindow* window = [KDTWindow sharedInstance];
        [window setUp];
    }
}





static __attribute__((constructor)) void _logosLocalCtor_0c3e1959() {
    @autoreleasepool {
        
    }
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);} }
#line 29 "/Users/wd/project/KDT/KDTWindow/KDTWindow/KDTWindow.xm"
