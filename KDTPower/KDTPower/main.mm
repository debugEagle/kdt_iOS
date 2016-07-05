//
//  main.m
//  KDTPower
//
//  Created by wd on 16-3-10.
//  Copyright (c) 2016年 __MyCompanyName__. All rights reserved.
//

#include <unistd.h>
#import <Foundation/Foundation.h>
#import "NSLuaCore.h"
#import "HPScriptClient.h"
#include "Touch.h"
#include "Graphics.h"
#include "KDTApi.h"

extern const char **environ;
int main (int argc, const char * argv[]) {
    @autoreleasepool {
        //setuid(0);
        //pid_t sid = setsid();
        //NSLog(@"%d", sid);
        
        Touch::init();
        Graphics::init();
        
        HPScriptClient* client = [HPScriptClient sharedInstance];
        NSLuaCore* core = [NSLuaCore sharedInstance];
        [core openApi:KDTApiOpen];
        if (!client.path) {
            [(id)client.proxy isStopBy: "没有选择脚本"];
            [client exit];
            client.path = @"/tmp";
        }
        char* path = (char*)[client.path UTF8String];
        //NSLog(@"chdir:%@", client.path);
        errno = 0;
        if (chdir(path) == -1) {
            [(id)client.proxy isStopBy: "设置工作路径失败"];
            NSLog(@"errno:%d", errno);
            [client exit];
        }
        //NSLog(@"current working directory: %s ",getcwd(NULL,NULL));
        [(id)client.proxy isReady: path];
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}

