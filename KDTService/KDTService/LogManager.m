//
//  LogManager.m
//  
//
//  Created by wd on 16/5/17.
//
//

#import "LogManager.h"

@implementation LogManager


+(id) sharedInstance {
    static LogManager* _manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _manager = [[LogManager alloc] init];
    });
    return _manager;
}


-(id) init {
    self = [super init];
    if (self) {
        _path = [[NSString alloc] initWithFormat:@"%@/log/KDTService.log", KDT_DOC_PATH] ;
    }
    return self;
}

+(void) append:(NSString*) fmt, ... {
    LogManager* manager = [self sharedInstance];
    va_list args;
    va_start (args, fmt);
    NSString* value = [[NSString alloc] initWithFormat: fmt arguments: args];
    va_end (args);
    [manager append:value];
}


-(void) append:(NSString*) log {
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.path]) {
        NSError* error = nil;
        [@"" writeToFile:self.path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) NSLog(@"创建文件失败:%@",error);
    }
    
    NSFileHandle* logFile = [NSFileHandle fileHandleForWritingAtPath:self.path];
    if(!logFile) {
        NSLog(@"打开日志文件失败");
        return;
    }
    
    NSString* fmted = [NSString stringWithFormat:@"[%@]:%@\n", [NSDate date], log];
    
    [logFile seekToEndOfFile];
    [logFile writeData:[fmted dataUsingEncoding:NSUTF8StringEncoding]];
    [logFile closeFile];
}


@end
