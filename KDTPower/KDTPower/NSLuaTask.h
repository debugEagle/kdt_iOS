//
//  NSLuaTask.h
//  PickMoney
//
//  Created by wd on 15-10-24.
//
//

#import <Foundation/Foundation.h>
#import "conf.h"


#define kStuts           @"运行状态"
#define kStutsInitial    @"initial"
#define kStutsLoading    @"loading"
#define kStutsRunning    @"running"
#define kStutsYield      @"yield"
#define KStutsDone       @"done"
#define KStutsErr        @"error"
#define KStutsKilled     @"killed"


@class NSLuaTask;

@protocol LuaTaskDelegate <NSObject>

@optional
-(int) beforeResume:(NSLuaTask*) task;
-(int) afterResume:(NSLuaTask*) task;

@required
-(lua_State*) creatThread:(NSLuaTask*) task;
-(dispatch_queue_t) dispatchQueue;

-(void) taskRunError:(NSLuaTask*) task;
-(void) taskEnd:(NSLuaTask*) task;
-(void) taskKill:(NSLuaTask*)task;

@end


@interface NSLuaTask : NSObject

-(id) initWithCore:(id<LuaTaskDelegate>) core;

/* setup */
-(void) setupCallBack:(lua_State*) from;
-(void) loadClosure:(lua_State*) from;
-(void) loadScript:(NSString*) scpath;

/* ENV */
-(id) getEnv:(id) key;
-(void) setEnv:(id) value forKey:(id) key;

/* dispatch */
-(void) push:(const char*)fmt, ...;
-(void) dispatch:(int)time;
-(int) kill;

@property (nonatomic, assign) lua_State* L;
@property (nonatomic, copy) NSString* path;
@property (nonatomic, retain) id<LuaTaskDelegate> delegate;

@end
