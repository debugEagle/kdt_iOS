//
//  AttachedCell.h
//  NT
//
//  Created by Kohn on 14-5-27.
//  Copyright (c) 2014年 Pem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScpCtlViewCell : UITableViewCell

@property (nonatomic,readonly) UIView* use;
@property (nonatomic,readonly) UIView* man;
@property (nonatomic,readonly) UIView* set;
@property (nonatomic,readonly) UIView* del;
@property (nonatomic,readonly) UIImageView* line;
@property (nonatomic,retain) id delegate;

-(void)tap:(id)sender;

@end
