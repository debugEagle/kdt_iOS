//
// Created by K on 6/11/15.
// Copyright (c) 2015 iOS Team. All rights reserved.
//

#import "RXUriActionEngine.h"

@implementation RXUriActionEngine
{
    NSMutableDictionary *_mapping;
}
singleton_implementation(RXUriActionEngine)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mapping = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)register:(id <EPUriActionHandlerProtocol>)handler
{
    NSString *key = [self generateKeyWithHandler:handler];
    _mapping[key] = handler;
}

- (BOOL)handle:(NSURL *)uri
{
    NSString *key = [self generateKeyWithUri:uri];

    id <EPUriActionHandlerProtocol> handler = _mapping[key];
    if (handler == nil)
    {
        return NO;
    }

    return [handler handleUri:uri];
}

- (NSString *)generateKeyWithHandler:(id <EPUriActionHandlerProtocol>)handler
{
    return [NSString stringWithFormat:@"%@_%@", handler.supportedScheme, handler.supportedHost];
}

- (NSString *)generateKeyWithUri:(NSURL *)uri
{
    return [NSString stringWithFormat:@"%@_%@", uri.scheme, uri.host];
}

@end