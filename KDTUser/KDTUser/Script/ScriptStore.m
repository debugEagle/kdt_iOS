//
//  ScriptStore.m
//  ATDemo
//
//  Created by hf on 15-3-13.
//  Copyright (c) 2015年 jailbreaker. All rights reserved.
//

#import "ScriptStore.h"

@interface ScriptStore ()


@property (nonatomic, copy) NSString *scriptsPath;

@end

@implementation ScriptStore

+ (instancetype)shared
{
    static ScriptStore *scriptStore = nil;
    
    if (!scriptStore) {
        scriptStore = [[ScriptStore alloc] initPrivate];
        
    }
    
    return scriptStore;
}


- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        self.scriptsPath = [NSString stringWithFormat:@"%@/script", KDT_DOC_PATH];
    }
    
    return self;
}

- (NSMutableArray *)allScripts
{
    NSError *error = nil;
    NSArray *scripts =  [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.scriptsPath error:&error]
                         pathsMatchingExtensions:[NSArray arrayWithObject:@"scp"]];
    if (nil == scripts) {
        NSLog(@"获取脚本列表失败");
    }
    
    NSMutableArray* scpinfos = [[NSMutableArray alloc]init];
    for(NSString* name in scripts){
        NSString* path = [NSString stringWithFormat:@"%@/%@",self.scriptsPath,name];
        NSString* info = [NSString stringWithFormat:@"%@/info.plist",path];
        NSString* setting = [NSString stringWithFormat:@"%@/settings.plist",path];
        NSString* icon = [NSString stringWithFormat:@"%@/icon.png",path];
        NSString* main = [NSString stringWithFormat:@"%@/main.lua",path];
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:main]) {
            continue;
        }
        
        NSMutableDictionary* dict = nil;
        
        if ([[NSFileManager defaultManager]fileExistsAtPath:info]) {
            dict = [[NSMutableDictionary alloc]initWithContentsOfFile:info];
        }
        if (!dict) {
            dict = [[NSMutableDictionary alloc]init];
        }
        
        NSString* scpname = [dict objectForKey:@"name"];
        if (!scpname) {
            [dict setObject:name forKey:@"name"];
        }
        
        NSString* descriptor = [dict objectForKey:@"descriptor"];
        if (!descriptor) {
            [dict setObject:@"这家伙很懒什么也没写" forKey:@"descriptor"];
        }
        
        NSString* author = [dict objectForKey:@"author"];
        if (!author) {
            [dict setObject:@"-" forKey:@"author"];
        }
        
        NSString* ver = [dict objectForKey:@"ver"];
        if (!ver) {
            [dict setObject:@"v1.0" forKey:@"ver"];
        }
        
        NSString* time = [dict objectForKey:@"time"];
        if (!time) {
            [dict setObject:@"1970-01-01" forKey:@"time"];
        }
        
        [dict setObject:@"Maincell" forKey:@"celltype"];
        [dict setObject:name forKey:@"id"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:setting]) {
            [dict setObject:setting forKey:@"settings"];
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:icon]) {
            [dict setObject:icon forKey:@"icon"];
        }
        
        [scpinfos addObject:dict];
        
    }
    NSLog(@"%@",scpinfos);
    
    return [scpinfos autorelease];
}





@end
