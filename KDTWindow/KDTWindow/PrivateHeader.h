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
#import <mach/mach.h>

int SBSLaunchApplicationWithIdentifier (NSString* identifier, BOOL b);
void SBSProcessIDForDisplayIdentifier (NSString* identifier, int* pid);
void* SBFrontmostApplicationDisplayIdentifier (mach_port_t port,char * result);
int SBSSpringBoardServerPort (void);
CFStringRef SBSApplicationLaunchingErrorString(int error);
kern_return_t mach_port_deallocate (ipc_space_t task, mach_port_name_t name);

#endif
