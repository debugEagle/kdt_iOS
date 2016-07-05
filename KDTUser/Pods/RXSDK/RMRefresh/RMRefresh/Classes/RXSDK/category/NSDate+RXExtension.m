//
//  NSDate+Extension.m
//  F4App
//
//  Created by Kratos on 15/4/13.
//  Copyright (c) 2015年 iOS Team. All rights reserved.
//

#import "NSDate+RXExtension.h"

@implementation NSDate (RXExtension)

/**
*  是否为今天
*/
- (BOOL)rx_isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;

    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];

    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
            (selfCmps.year == nowCmps.year) &&
                    (selfCmps.month == nowCmps.month) &&
                    (selfCmps.day == nowCmps.day);
}

/**
*  是否为昨天
*/
- (BOOL)rx_isYesterday {
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] rx_dateWithYMD];

    // 2014-04-30
    NSDate *selfDate = [self rx_dateWithYMD];

    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)rx_dateWithYMD {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
*  是否为今年
*/
- (BOOL)rx_isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;

    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];

    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];

    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)rx_deltaWithNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

+ (NSString *)rx_timestampStrWithDate:(NSDate *)date
{
    NSDate *newDate = nil;
    if (date == nil) {
        newDate = [NSDate date];
    } else {
        newDate = date;
    }
    return [NSString stringWithFormat:@"%zd", (NSInteger)[newDate timeIntervalSince1970]];
}

+ (NSString *)rx_createDate:(NSDate *)createdDate {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss"; //日期格式化
    if (createdDate.rx_isToday) {
        fmt.dateFormat = @"HH:mm";
        return [fmt stringFromDate:createdDate];
    } else if (createdDate.rx_isYesterday) { // 昨天
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    } else if (createdDate.rx_isThisYear) { // 今年(至少是前天)
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    } else { // 非今年
        fmt.dateFormat = @"yy-MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    }
}

+ (NSString *)rx_timestampStrWithDateStr:(NSString *)dateStr format:(NSString *)format
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = format;
    NSDate *date = [fmt dateFromString:dateStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)rx_createDateWithYYYYMMDD:(NSDate *)createdDate
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY-MM-dd HH:mm:ss"; //日期格式化
    if (createdDate.rx_isToday) {
        fmt.dateFormat = @"yyyy年MM月dd日";
        return [fmt stringFromDate:createdDate];
        
    } else if (createdDate.rx_isYesterday) { // 昨天
        fmt.dateFormat = @"yyyy年MM月dd日";
        return [fmt stringFromDate:createdDate];
    } else if (createdDate.rx_isThisYear) { // 今年(至少是前天)
        fmt.dateFormat = @"yyyy年MM月dd日";
        return [fmt stringFromDate:createdDate];
    } else { // 非今年
        fmt.dateFormat = @"yyyy年MM月dd日";
        return [fmt stringFromDate:createdDate];
    }

}

+ (NSString *)rx_transTimeWithTimeString:(NSString *)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    return [NSDate rx_createDate:date];
}

@end
