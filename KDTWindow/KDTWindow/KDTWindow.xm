

#import "KDTWindow.h"
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

%hook SpringBoard

-(void)applicationDidFinishLaunching: (id)application
{
    @autoreleasepool {
        %orig;
        KDTWindow* window = [KDTWindow sharedInstance];
        [window setUp];
    }
}

%end



%ctor {
    @autoreleasepool {
        
    }
}

