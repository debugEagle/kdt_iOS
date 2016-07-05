//
//  Header.h
//  arpower
//
//  Created by wd on 15-7-13.
//
//

#ifndef arpower_Header_h
#define arpower_Header_h
#import <Foundation/Foundation.h>
#import <mach/mach_port.h>
#import <mach/mach_init.h>
#ifdef __cplusplus

extern "C" {
#endif
    
    int SBSLaunchApplicationWithIdentifier (NSString* identifier, BOOL b);      //启动app
    void SBSProcessIDForDisplayIdentifier (NSString* identifier, int* pid);     //根据app获得pid
    void* SBFrontmostApplicationDisplayIdentifier (mach_port_t port,char * result);     //获得前台应用appid
    NSString * SBSCopyFrontmostApplicationDisplayIdentifier();
    NSString * SBSCopyDisplayIdentifierForProcessID(int pid);
    int SBSSpringBoardServerPort (void);
    kern_return_t mach_port_deallocate (ipc_space_t task, mach_port_name_t name);
    
#ifdef __cplusplus
}
#endif



#endif
