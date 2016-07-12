//
//  NSArray+Extend.h
//  OMNI
//
//  Created by changxicao on 16/7/12.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extend)

/**
 *获取当前日期
 */
+ (NSDictionary *)calculationNowTime;

/**
 *设置默认时间
 */
+ (NSDictionary *)calculationDefaultTime:(NSString *)defaultTime;

/**
 *获取年
 */
+ (NSArray *)calculationYear;

/**
 *获取月
 */
+ (NSArray *)calculationMonth;

/**
 *根据月份获取天数
 */
+ (NSArray *)calculationDay:(NSString *)iyear andMonth:(NSString *)month;

/**
 *获取时
 */
+ (NSArray *)calculationHH;

/**
 *获取分
 */
+ (NSArray *)calculationMM;

/**
 *根据时间获取星期几
 */
+ (NSString *)ObtainWeek:(NSString *)day andMonth:(NSString *)month andYear:(NSString *)year;
@end
