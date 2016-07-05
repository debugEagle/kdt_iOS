//
//  Header.h
//  arhp
//
//  Created by wd on 15-5-28.
//
//

#ifndef arhp_Header_h
#define arhp_Header_h

#import <Foundation/Foundation.h>

#define HPControlServiceName "com.kdt.arhp.ctl"
#define HPScriptServiceName "com.kdt.arhp.scp"
#define HPSpringBoardServiceName "com.kdt.arhp.sp"


/* ScriptService */
#define kStutsWaiting    @"等待连接"
#define kStutsVerify     @"等待验证"
#define kStutsRuning     @"运行中"

/* LocalService */
#define kStutsListening  @"监听状态"


@protocol RunTimeProtocol
- (void) log:(char*)string;                 //脚本日志
- (void) isReady:(char*)path;               //脚本准备就绪,脚本路径
- (void) isResumeBy:(char*)reson;           //脚本被某些原因启动了
- (void) isSuspendBy:(char*)reson;          //脚本被某些原因挂起了
- (void) isStopBy:(char*)reson;             //脚本被某些原因停止了
@end


//app->arhp
@protocol LocalServiceProtocol
- (void) login;
- (void) licence;
- (void) status;                            //向客户端返回服务端状态
- (void) startListen;                       //开始监听
- (void) stopListen;                        //停止监听
- (void) open;                              //开始脚本
- (void) close;                             //停止脚本
@end


//arhp->app
@protocol LocalClientProtocol
- (void) onLogin;
- (void) onLicence:(NSDictionary*) licence;
- (void) onStatus:(NSDictionary*) status;                 //获得服务端状态
@end


//arhp->sb
@protocol SpringBoardClientProtocol <RunTimeProtocol>
-(void) onLogin;
-(void) menuVisible:(int) op;
-(void) menuVisibleChange;
-(void) showText:(char*) text;
@end


//sb->arhp
@protocol SpringBoardServiceProtocol
- (void) login;
- (void) open;                              //开始脚本
- (void) close;                             //停止脚本
@end


//arpower->arhp
@protocol ScriptServiceProtocol <RunTimeProtocol>

@end


//arhp->arpower
@protocol ScriptClientProtocol
- (void) setLicence:(NSData*)licence;
- (void) start;
- (void) stop;
@end





#endif
