//
//  EPSystemMsgJoinDepartmentHandler.m
//  EPIMApp
//
//  Created by Ryan on 15/11/13.
//  Copyright © 2015年 Ryan. All rights reserved.
//

#import "RXExampleHandler.h"
#import "RXUriActionEngine.h"

@interface RXExampleHandler ()

@end

@implementation RXExampleHandler

- (void)load
{
    [[RXUriActionEngine sharedInstance] register:self];
}

- (NSString *)supportedScheme
{
    return @"system";
}

- (NSString *)supportedHost
{
    return @"department";
}

- (BOOL)handleUri:(NSURL *)uri
{
//    NSDictionary *dic = [NSMutableDictionary dealUrlParmasWithQuery:uri.query];
//    self.enterpriseID = dic[@"enterprise_id"];
//    self.departmentID = dic[@"department_id"];
//    
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//    
//    void (^onSuccessHandler)(NSString *, NSString *, EPEnterpriseInfo *) = ^(NSString *department,
//                                                                             NSString *enterprise,
//                                                                             EPEnterpriseInfo *info)
//    {
//        [SVProgressHUD dismiss];
//        
//        self.info = info;
//        
//        NSString *departmentName;
//        
//        if ([info.departmentName isEqualToString:department] &&
//            [info.enterpriseName isEqualToString:enterprise])
//        {
//            [SVProgressHUD showErrorWithStatus:@"已加入该部门"];
//            return;
//        }else if (info.departmentName.length > 0 && info.enterpriseName.length > 0)
//        {
//            departmentName = [NSString stringWithFormat:@"是否退出%@%@，加入%@%@",
//                              info.enterpriseName, info.departmentName, enterprise, department];
//        }else
//        {
//            departmentName = [NSString stringWithFormat:@"是否加入%@%@", enterprise, department];
//        }
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                           message:departmentName
//                                                          delegate:self
//                                                 cancelButtonTitle:@"取消"
//                                                 otherButtonTitles:@"加入", nil];
//        [alertView show];
//    };
//    
//    [EPEnterpriseManager getEnterpriseInfoWithEnterpriseId:[_enterpriseID integerValue]
//                                              departmentId:[_departmentID integerValue]
//                                                 OnSuccess:onSuccessHandler
//                                                 onFailure:nil];
    return YES;
}

@end
