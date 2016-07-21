//
//  NSDate+Extend.m
//  OMNI
//
//  Created by changxicao on 16/7/12.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

+ (NSDate *)convertDateFromString:(NSString *)string format:(NSString *)format
{
    if (!format) {
        format = @"yyyy/MM/dd HH:mm";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    if (!format) {
        format = @"yyyy/MM/dd HH:mm";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

@end
