//
//  MultifyWindow.m
//  tweaktest
//
//  Created by wd on 15-8-9.
//
//
#import <Foundation/Foundation.h>
#import "KDTWindow.h"
#import "KDTNotifyView.h"
#import "HPWindowClient.h"
#import <objc/runtime.h>
#import "PrivateHeader.h"

#define noerr

#ifdef noerr

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"

#endif


typedef id SBApplication;
typedef id FBScene;
typedef UIView FBWindowContextHostWrapperView;


@implementation KDTWindow {
    KDTNotifyView*      notifyView;
    WDMenuView*         menu;
}

+(id)sharedInstance {
    static KDTWindow* window;
    if (window == NULL){
        window = [[KDTWindow alloc]init];
    }
    return window;
}


UIKIT_EXTERN const UIWindowLevel UISpringBoardStatusBarWindowLevel;
UIKIT_EXTERN const UIWindowLevel UISpringBoardBulletinListWindowLevel;
UIKIT_EXTERN const UIWindowLevel UISpringBoardLockScreenWindowLevel;
UIKIT_EXTERN const UIWindowLevel UISpringBoardLockedStatusBarWindowLevel;
UIKIT_EXTERN const UIWindowLevel UISpringBoardTextEffectsOverNotificationCenterWindowLevel;


-(id) init {
    NSLog(@"MultifyWindow init");
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bounds = [UIScreen mainScreen].bounds;
        [self setWindowLevel:UISpringBoardStatusBarWindowLevel + 1.f];
        stuts = 0;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != self)
    {
        return hitView;
    }
    else
    {
        return nil;
    }
}


/* －－－－－－－－－－－－－－－－－－－－－cmd 接口－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－*/

static
CFDataRef engineCallBack(CFMessagePortRef local,SInt32 msgid,CFDataRef cfData, void*info)
{
    WDLog("Recve Message!\n");
    CFDataRef ret_data = nil;
    KDTWindow* window = [KDTWindow sharedInstance];
    
    switch (msgid) {
        case menu_game_show:
            [window showAppView];
            break;
        case menu_game_hide:
            [window hideAppView];
            break;
        case menu_show:
            [window show];
            break;
        case menu_hide:
            [window hide];
            break;
        default:
            break;
    }
    return ret_data;
}


//安装窗口
-(void) setUp {
    WDLog(".");
    
    notifyView = [[KDTNotifyView alloc]init];
    
    menu = [[WDMenuView alloc]  initWithCenter:CGPointMake(30, 150)
                                 bigMenuRadius:30.f
                                 subMenuRadius:20.f
                                        upView:self
                                    themeColor:[UIColor orangeColor]];
    menu.menu_delegate = self;
    
    
    menu.big_menu_image.image = [UIImage imageNamed:@"/Library/Application Support/XMultify/big_menu_1.png"];
    
    NSDictionary* menu_a = @{
                             key_WDSubMenu_id               :@"menu_a",
                             key_WDSubMenu_radius           :@20.f,
                             key_WDSubMenu_distance         :@30.f,
                             key_WDSubMenu_backgroundImage  :@"/Library/Application Support/XMultify/menu_a.png",
                             };
    
    NSDictionary* menu_b = @{
                             key_WDSubMenu_id               :@"menu_b",
                             key_WDSubMenu_radius           :@20.f,
                             key_WDSubMenu_distance         :@30.f,
                             key_WDSubMenu_backgroundImage  :@"/Library/Application Support/XMultify/menu_b.png",
                             };
    
    NSDictionary* menu_c = @{
                             key_WDSubMenu_id               :@"menu_c",
                             key_WDSubMenu_radius           :@20.f,
                             key_WDSubMenu_distance         :@30.f,
                             key_WDSubMenu_backgroundImage  :@"/Library/Application Support/XMultify/menu_c.png",
                             };
    
    [menu addSubMenu:menu_a];
    [menu addSubMenu:menu_b];
    [menu addSubMenu:menu_c];
    
    [self addSubview:notifyView];
    [self sendSubviewToBack:notifyView];
    
#warning 初始默认隐藏
    [menu visible:NO];
    
    CFMessagePortRef port = CFMessagePortCreateLocal(kCFAllocatorDefault,CFSTR(MULTIFYPORT),engineCallBack, NULL, NULL);
    if (port == NULL) {
        NSLog(@"messageModule_init error,port\n");
        return;
    }
    CFRunLoopSourceRef source = CFMessagePortCreateRunLoopSource(kCFAllocatorDefault, port, 0);
    CFRunLoopAddSource(CFRunLoopGetMain(), source, kCFRunLoopCommonModes);
    
    [HPWindowClient sharedInstance];
    
    /* windows show */
    [self show];
}


#warning 卸载窗口
- (void) unload {
    [self hide];
}


- (void) powerDown {
    id SpringBoard = [UIApplication sharedApplication];
    [SpringBoard powerDown];
}


-(void) show {
    [self setAlpha:1.f];
    [self makeKeyAndVisible];
}


-(void) hide {
    [self setAlpha:0.f];
    [self resignKeyWindow];
}


- (void) menuVisible: (BOOL) op {
    [menu visible:op];
}


- (void) menuVisibleChange {
    [menu visibleChange];
}

- (void) menuRotate: (BOOL) op {
    [menu rotate:op];
}

- (void) showText:(NSString*) text {
    [notifyView showText:text];
}

- (void) isResumeBy:(char*)reson {
    [self setMode:STUTS_KDT_RUNING to:1];
    [menu rotate:YES];
    [notifyView showText:NS_String(reson)];
}


- (void) isSuspendBy:(char*)reson {
    
}


- (void) isStopBy:(char*)reson {
    [self setMode:STUTS_KDT_RUNING to:0];
    [menu rotate:NO];
    [menu visible:YES];
    [notifyView showText:NS_String(reson)];
}


- (void) setMode:(Enum_MultifyWindowStuts) stuts_mask to:(UInt32)value {
    (value) ? (stuts |= (1 << stuts_mask)) : (stuts &= ~(1 << stuts_mask));
}


- (bool) inMode:(Enum_MultifyWindowStuts) stuts_mask {
    return stuts & (1 << stuts_mask);
}


-(void)MenuDidSelected:(NSString*)key {
    WDLog("选中%@",key);
    HPWindowClient* hp = [HPWindowClient sharedInstance];
    if ([key isEqualToString:@"menu_a"]) {
        [(id)hp.proxy open];
    }
    
    if ([key isEqualToString:@"menu_b"]) {
        [(id)hp.proxy close];
    }
    
    if ([key isEqualToString:@"menu_c"]) {
        NSString* appid = @"com.kdt.cn.KDTUser";
        int ret = [[UIApplication sharedApplication] launchApplicationWithIdentifier:appid suspended:0];
        WDLog("%@ 启动失败:%@", appid, SBSApplicationLaunchingErrorString(ret));
    }
}


#ifdef noerr
#pragma clang diagnostic pop
#endif
@end


