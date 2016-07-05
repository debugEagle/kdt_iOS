//
//  TVC.h
//  ui
//
//  Created by wd on 15-6-21.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScpCtlViewCell.h"
#import "ScpViewCell.h"

@interface ScpController : UITableViewController

@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, copy) NSIndexPath* expand;
@property (nonatomic, copy) NSIndexPath* select;
@property (nonatomic, copy) NSString* selectID;

- (void) handleEvent:(NSInteger)arg;

@end
