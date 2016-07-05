//
//  UITableViewCell+UITableViewCell_Ident.m
//  KDTUser
//
//  Created by wd on 16/5/4.
//  Copyright © 2016年 wd. All rights reserved.
//

#import "UITableViewCell+Ident.h"

@implementation UITableViewCell (Ident)

+ (NSString*) ident {
    return NSStringFromClass(self);
}

@end
