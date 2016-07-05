//
//  NSLuaTask.m
//  PickMoney
//
//  Created by wd on 15-10-24.
//

#import "3rd/lua/lua.hpp"
#import "NSLuaTask.h"
#import "HPScriptClient.h"


#pragma mark- NSLuaTask api



#pragma mark-

@implementation NSLuaTask {
    NSMutableDictionary*    ENV;
    int                     nargs;
}


-(id) initWithCore:(id<LuaTaskDelegate>) core {
    if (self = [super init]) {
        self.path = @"";
        ENV = [[NSMutableDictionary alloc] init];
        [self setEnv:kStutsInitial forKey:kStuts];
        _delegate = (id)[core retain];
        _L = [_delegate creatThread:self];
        id* extra = lua_getextraspace(_L);
        *extra = self;
    }
    return self;
}


-(void) dealloc {
    WDLog("L:%p dealloc", _L);
    [ENV release];
    [_delegate release];
    [super dealloc];
}


-(id) getEnv:(id) key {
    return [ENV objectForKey:key];
}


-(void) setEnv:(id) value forKey:(id) key {
    if (value)
        [ENV setObject:value forKey:key];
    else
        [ENV removeObjectForKey:key];
}


-(void) setupCallBack:(lua_State*) from {
    if (!lua_isfunction(from, -1)) {
        lua_pop(from, 1);
        return;
    }
    
    lua_rawgetp(from, LUA_REGISTRYINDEX, self);
    assert(lua_istable(from, -1));
    lua_pushstring(from, "callback");
    lua_rotate(from, -3, -1);   /* [table] [key] [value] */
    lua_rawset(from, -3);
    lua_pop(from, 1);
}


-(void) loadClosure:(lua_State*) from {
    self.path = [NSString stringWithFormat:@"lambda_%p", self.L];
    lua_xmove(from, _L, 1);
    [self setEnv:kStutsYield forKey:kStuts];
}


-(void) loadScript:(NSString*) scpath {
    self.path = scpath;
    int ret = luaL_loadfile(_L, [self.path UTF8String]);
    if (ret != LUA_OK) {
        [self setEnv:KStutsErr forKey:kStuts];
        [_delegate taskRunError:self];
        return;
    }
    [self setEnv:kStutsYield forKey:kStuts];
}


- (void) dispatch:(int)time {
    __block NSLuaTask* task = [self retain];
    dispatch_queue_t queue = [_delegate dispatchQueue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_MSEC)), queue, ^{
        @autoreleasepool {
            [task resume];
            [task release];
        }
    });
}


-(int) kill {
    NSString* stauts = [self getEnv:kStuts];
    if ([@[KStutsDone,
           KStutsKilled,
           KStutsErr] indexOfObject:stauts] != NSNotFound) {
        WDLog("thread is die");
        return 0;
    }
    
    [self setEnv:KStutsKilled forKey:kStuts];
    [_delegate taskKill:self];
    return 1;
}


-(void) resume {
    WDLog("%@", ENV);
    if (![[self getEnv:kStuts] isEqualToString:kStutsYield]) return;
    
    if ([_delegate respondsToSelector:@selector(beforeResume:)])
        [_delegate beforeResume:self];
    /* set running */
    [self setEnv:kStutsRunning forKey:kStuts];
    int ret = lua_resume(_L, nil, nargs);
    switch (ret) {
        case LUA_OK:
            [self setEnv:KStutsDone forKey:kStuts];
            [_delegate taskEnd:self];
            break;
        case LUA_YIELD:
            if ([_delegate respondsToSelector:@selector(afterResume:)])
                [_delegate afterResume:self];
            [self setEnv:kStutsYield forKey:kStuts];
            nargs = 0;
            break;
        default:
            [self setEnv:KStutsErr forKey:kStuts];
            [_delegate taskRunError:self];
            break;
    }
}


-(void) push:(const char*)fmt, ... {
    if (![[self getEnv:kStuts] isEqualToString:kStutsYield]) return;
    
    va_list args;
    const char* s;
    const char* e;
    int d;
    char c;
    lua_Number f;
    char error_msg[256];
    id obj;
    
    va_start(args, fmt);
    
    for (NSInteger i = 1 ;; i++) {
        e = strchr(fmt, '%');
        if (e == NULL) break;
        switch (*(e + 1)) {
            case 's':
            {
                s = va_arg(args, char *);
                if (s == nil)
                    lua_pushnil(_L);
                else
                    lua_pushstring(_L, s);
                break;
            }
            case '@':       //目前支持 NSString，NSData，NSDictionary
            {
                obj = va_arg(args, id);
                if ([obj isKindOfClass:[NSString class]])
                {
                    lua_pushstring(_L, [obj UTF8String]);
                    break;
                }
                if ([obj isKindOfClass:[NSData class]])
                {
                    lua_pushlstring(_L, [obj bytes], [obj length]);
                    break;
                }
                if ([obj isKindOfClass:[NSDictionary class]])
                {
                    lua_newtable(_L);
                    for (NSString* key in obj)
                    {
                        id v = [obj objectForKey:key];
                        if ([v isKindOfClass:[NSString class]])
                        {
                            lua_pushstring(_L, [v UTF8String]);
                            lua_setfield(_L, -2, [key UTF8String]);
                        }
                    }
                    break;
                }
                goto err;
                //lua_pushnil(L);
                //break;
            }
            case 'c':
            {
                c = cast(char, va_arg(args, int));
                lua_pushlstring(_L, &c, 1);
                break;
            }
            case 'd':
            {
                d = va_arg(args, int);
                lua_pushinteger(_L, d);
                break;
            }
            case 'f':
            {
                f = va_arg(args, lua_Number);
                lua_pushnumber(_L, f);
                break;
            }
                
            default:
                goto err;
        }
        fmt = e + 2;
        ++nargs;
    }
    
    va_end(args);
    
    return;
    
err:
    sprintf(error_msg, "unknow type: %c", *(e + 1));
    assert(!error_msg);
}


@end
