//
//  LicenceInputView.h
//  KDTUser
//
//  Created by wd on 16/5/16.
//  Copyright © 2016年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OKHandler)(NSString* licence);
typedef void(^CancelHandler)(NSString* licence);

@interface LicenceInputView : UIAlertView<UIAlertViewDelegate>

@property (copy) OKHandler OKBlock;
@property (copy) CancelHandler CancelBlock;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id )delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
