//
// Created by Kut Zhang on 11/6/14.
// Copyright (c) 2014 Kut Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (SDK_Encrypt)

- (NSData *)sdk_AESEncryptWithKey:(NSString *)key;

- (NSData *)sdk_AESDecryptWithKey:(NSString *)key;

@end