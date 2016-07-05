//
//  PreferenceLoaderDemoController.h
//  PreferenceLoaderDemo
//
//  Created by wd on 15-5-9.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

@interface KDTCustom : PSListController

@property(nonatomic, copy) NSString* scriptPath;

- (id)init;
- (void)dealloc;

//- (id)navigationTitle;
- (id)initWithPath:(NSString*)path;
- (id)specifiers;
- (id)readPreferenceValue:(PSSpecifier*)specifier;
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier;
- (void)visitWebSite:(PSSpecifier*)specifier;

@end