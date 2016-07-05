//
//  LogManager.h
//  
//
//  Created by wd on 16/5/17.
//
//

#import <Foundation/Foundation.h>

#define kPrefs_Path @"/var/mobile/Media/KDTScript"

@interface LogManager : NSObject

@property (nonatomic,copy) NSString* path;
@property (nonatomic,strong) NSFileHandle* logFile;

+(id) sharedInstance;

+(void) append:(NSString*) fmt, ...;
+(void) append:(NSString*) log;

@end
