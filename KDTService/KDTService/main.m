//
//  main.m
//  arhp
//
//  Created by wd on 15-5-23.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

// XPC Service: Lightweight helper tool that performs work on behalf of an application.
// see http://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingXPCServices.html

#import <xpc/xpc.h> // Create a symlink to OSX's SDK. For example, in Terminal run: ln -s /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk/usr/include/xpc /opt/iOSOpenDev/include/xpc

//照着上面的做法找到xpc头文件

#import <Foundation/Foundation.h>
#import "HPLocalService.h"
#import "HPScriptService.h"
#import "HPSpringBoardService.h"

static
void CrashHandlerExceptionHandler(NSException *exception) {
    NSLog(@"%@",[exception callStackSymbols]);
}

static
void sig_chld(int signo) {
    pid_t   pid;
    int     stat;
    while((pid = waitpid(-1, &stat, WNOHANG)) > 0){
        NSLog(@"child %d terminated", pid);
    }
    return;
}


int main(int argc, const char *argv[])
{
    signal(SIGCHLD,sig_chld);
    NSSetUncaughtExceptionHandler (&CrashHandlerExceptionHandler);
    
    if (HPLocalSerivce_init())
        NSLog(@"HPCoreSerivce_init error");
    
    if (HPScriptSerivce_init())
        NSLog(@"HPCoreSerivce_init error");
    
    if (HPSpringBoardService_init())
        NSLog(@"HPCoreSerivce_init error");
    
    CFRunLoopRun();
    return EXIT_SUCCESS;
}
