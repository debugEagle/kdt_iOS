//
//  RXApiEngine.m
//  RXSDK
//
//  Created by Ryan on 15/11/17.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "RXApiEngine.h"
@implementation RXApiEngine
singleton_implementation(RXApiEngine)

- (instancetype)init
{
    self = [super initWithBaseUrl:@"http://42.120.16.240/beetto_wendy/index.php?app=mapi"
                        secretKey:nil];
    return self;
}

@end
