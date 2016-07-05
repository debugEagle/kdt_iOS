//
//  PreferenceLoaderDemoController.m
//  PreferenceLoaderDemo
//
//  Created by wd on 15-5-9.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import "KDTCustom.h"
#import <Preferences/PSSpecifier.h>


//NSArray* SpecifiersFromPlist(NSDictionary* dict, PSSpecifier* specifier, id target, CFStringRef title,
//                             NSMutableArray* bc ,id b, int* c,int* d,NSBundle* bundle);
NSArray* SpecifiersFromPlist(NSDictionary* dict, PSSpecifier* specifier, id target, CFStringRef title,
                             NSBundle* bundle, int* c, int* d, id b, NSMutableArray* bc);



#define kPrefs_KeyName_Key @"key"
#define kPrefs_KeyName_Defaults @"default"
#define kPreFs_KeyName_Redirect @"redirect"

@implementation KDTCustom


+(id) sharedInstance {
    static KDTCustom* _controller;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _controller = [[KDTCustom alloc] init];
    });
    return _controller;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                    target:self
                                                                                    action:@selector(hideKeyBoard)];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self hideKeyBoard];
}



-(void) hideKeyBoard {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView   *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    WDLog("firstResponder:%@", firstResponder);
    [firstResponder resignFirstResponder];
    
}


- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *properties = [specifier properties];
    NSString *specifierKey = [properties objectForKey:kPrefs_KeyName_Key];
    
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:self.scriptPath];
    
    NSDictionary* Settings = [dict objectForKey:@"Settings"];
    
    /* value  ->  redirect ->  defaults */
    id objectValue = [Settings objectForKey:specifierKey];
    if (objectValue) goto success;
    
    id redirect = [properties objectForKey:kPreFs_KeyName_Redirect];
    if (redirect) {
        Settings = [NSDictionary dictionaryWithContentsOfFile:redirect];
        objectValue = [Settings objectForKey:specifierKey];
        if (objectValue) goto success;
    }
    
    objectValue = [properties objectForKey:kPrefs_KeyName_Defaults];
    if (objectValue) {
        /* 首次获取 将默认的设置保存到 settings里 */
        [self setPreferenceValue:objectValue specifier:specifier];
        goto success;
    }
    
failed:
    return nil;
    
success:
    return [NSString stringWithFormat:@"%@", objectValue];
}


-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier; {
    if (!value) return;
    
    NSDictionary *properties = [specifier properties];
    NSString *specifierKey = [properties objectForKey:kPrefs_KeyName_Key];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:self.scriptPath];
    if (!dict) dict = [NSMutableDictionary dictionary]; /* 无ui 保存 */
    
    NSMutableDictionary* Settings = [dict objectForKey:@"Settings"];
    if (!Settings) {
        Settings = [NSMutableDictionary dictionary];
        [dict setObject:Settings forKey:@"Settings"];
    }
    
    [Settings setObject:value forKey:specifierKey];
    [dict writeToFile:self.scriptPath atomically:YES];
    
    NSLog(@"saved key '%@' with value '%@' to plist '%@'", specifierKey, value, self.scriptPath);
}


-(void) visitWebSite:(PSSpecifier*) specifier {
    NSDictionary *specifierProperties = [specifier properties];
    NSString *web = [specifierProperties objectForKey:@"web"];
    
    WDLog(@"default:%@",web);
    if (!web) web = @"";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:web]];
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//    id view = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//}



-(id) specifiers {
    if (_specifiers == nil) {
        NSDictionary* dict =  [NSDictionary dictionaryWithContentsOfFile:self.scriptPath];
        NSDictionary* set = [dict objectForKey:@"Designs"];
        WDLog("specifiers:%@", _specifiers);
        WDLog("dict:%@",set);
        if (set == nil) return nil;
        
        int a = 0, b = 0;
        _specifiers = SpecifiersFromPlist(set,self.specifier,self,CFSTR(""),[self bundle],&a,&b,self,self->_bundleControllers);
        
        WDLog("_specifiers:%@", _specifiers);
        
        [_specifiers retain];
    }
    return _specifiers;
}



-(id) init {
    if (self = [super init]) {
        
    }
    return self;
}


- (void)dealloc
{
    WDLog("plistview dealloc");
    [super dealloc];
}



-(id) initWithPath:(NSString*) path
{
    if ((self = [super init])) {
        self.scriptPath = path;
        NSLog(@"path:%@  %p",self.scriptPath,self);
    }
    return self;
}


@end