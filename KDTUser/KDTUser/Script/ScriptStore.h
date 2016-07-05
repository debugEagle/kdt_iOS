//
//  ScriptStore.h
//  ATDemo
//
//  Created by hf on 15-3-13.
//  Copyright (c) 2015年 jailbreaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScriptStore : NSObject

@property (nonatomic, readonly) NSMutableArray* allScripts;

+ (instancetype)shared;

@end
