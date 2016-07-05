//
//  LicenceInputView.m
//  KDTUser
//
//  Created by wd on 16/5/16.
//  Copyright © 2016年 wd. All rights reserved.
//

#import "LicenceInputView.h"

@interface LicenceInputView()


@property (nonatomic, strong) UITextView *inputView;

@end

@implementation LicenceInputView


-(instancetype) init {
    self = [super init];
    if (self) {
//        _inputView = [[UITextView alloc] initWithFrame:self.frame];
//        [self addSubview:_inputView];
    }
    return self;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    
}

@end
