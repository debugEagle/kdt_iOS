//
//  MultifyWindow.h
//  tweaktest
//
//  Created by wd on 15-8-9.
//
//

#import <UIKit/UIKit.h>
#import "WDMenuView.h"

typedef enum  {
    GET_STSTS,
    WINDOW_SHOW,            
    WINDOW_HIDE,
    APP_SHOW,
    APP_HIDE,
    SET_APP_MULTIFY,
    GET_APP_LIST,
    CHANGE_MODE,
} cfmsgID;


#warning WATCHDOG_ADDTION
typedef enum {
    menu_game_show,
    menu_game_hide,
    menu_show,
    menu_hide,
    menu_start,
    menu_stop,
} menuID;


typedef enum {
    STUTS_KDT_RUNING,
}Enum_MultifyWindowStuts;


#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define MULTIFYPORT   "X.multify.port"


@interface KDTWindow : UIWindow <WDMenuViewDelegate> {
    UInt32      stuts;
}

+ (id) sharedInstance;
- (id) init;
- (void) setUp;
- (void) unload;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;

- (void) powerDown;
- (void) show;
- (void) hide;

- (void) menuVisibleChange;
- (void) menuVisible: (BOOL) op;
- (void) menuRotate: (BOOL) op;

- (void) showText:(NSString*) text;

- (void) isResumeBy:(char*)reson;           //脚本被某些原因启动了
- (void) isSuspendBy:(char*)reson;          //脚本被某些原因挂起了
- (void) isStopBy:(char*)reson;             //脚本被某些原因停止了

- (void) setMode:(Enum_MultifyWindowStuts) stuts_mask to:(UInt32)value;
- (bool) inMode:(Enum_MultifyWindowStuts) stuts_mask;

- (void) MenuDidSelected:(NSString*)key;

@end

