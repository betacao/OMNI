//
//  NSArray+Extend.m
//  OMNI
//
//  Created by changxicao on 16/7/12.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import "NSArray+Extend.h"

@implementation NSArray (Extend)

/**
 *获取当前日期
 */
+ (NSDictionary *)calculationNowTime{

    NSString *format = @"YYYY-MM-dd HH:mm";
    NSDate *senddate = [NSDate date];

    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    NSString *time = [dateformatter stringFromDate:senddate];

    NSArray *ary = [time componentsSeparatedByString:@" "];
    NSArray *ary1 = [ary[0] componentsSeparatedByString:@"-"];
    NSArray *ary2 = [ary[1] componentsSeparatedByString:@":"];

    return @{@"year":[ary1[0] stringByAppendingString:@""],
             @"month":[NSString stringWithFormat:@"%02tu",[ary1[1] integerValue]],
             @"day":[NSString stringWithFormat:@"%02tu",[ary1[2] integerValue]],
             @"hh":[NSString stringWithFormat:@"%02tu",[ary2[0] integerValue]],
             @"mm":ary2[1]};

}

/**
 *设置默认时间
 */
+ (NSDictionary *)calculationDefaultTime:(NSString *)defaultTime{

    NSString *format = @"YYYY-MM-dd HH:mm";

    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    NSDate *senddate = [dateformatter dateFromString:defaultTime];
    NSString *time = [dateformatter stringFromDate:senddate];

    NSArray *ary = [time componentsSeparatedByString:@" "];
    NSArray *ary1 = [ary[0] componentsSeparatedByString:@"-"];
    NSArray *ary2 = [ary[1] componentsSeparatedByString:@":"];

    return @{@"year":ary1[0],
             @"month":[NSString stringWithFormat:@"%tu",[ary1[1] integerValue]],
             @"day":[NSString stringWithFormat:@"%tu",[ary1[2] integerValue]],
             @"hh":[NSString stringWithFormat:@"%tu",[ary2[0] integerValue]],
             @"mm":ary2[1]};

}

/**
 *获取年
 */
+ (NSArray *)calculationYear{

    NSMutableArray *arry = [[NSMutableArray alloc] init];

    for (NSInteger i = 1900; i<=3000; i++) {

        NSString *str = [NSString stringWithFormat:@"%tu",i];
        [arry addObject:str];

    }
    return arry;
}

/**
 *获取月
 */
+ (NSArray *)calculationMonth
{
    return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
}

/**
 *根据年份和月份获取天数
 */
+ (NSArray *)calculationDay:(NSString *)iyear andMonth:(NSString *)month{

    NSInteger year = [iyear integerValue];
    NSInteger imonth = [month integerValue];

    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
    {
        return [self getDays:31];
    }

    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
    {
        return [self getDays:30];
    }

    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return [self getDays:28];
    }

    if(year%400 == 0)
    {
        return [self getDays:29];
    }

    if(year%100 == 0)
    {
        return [self getDays:28];
    }

    return [self getDays:29];
}

/**
 *获取时
 */
+ (NSArray *)calculationHH{
    return @[@"00", @"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
}

/**
 *获取分
 */
+ (NSArray *)calculationMM{
    return @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
}

+ (NSArray *)getDays:(NSInteger)num{
    if(num == 28){
        return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28"];
    }
    if(num == 29){
        return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29"];
    }
    if(num == 30){
        return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"];
    }
    if(num == 31){
        return @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    }
    return nil;
}

/**
 *根据时间获取星期几
 */
+ (NSString *)ObtainWeek:(NSString *)day andMonth:(NSString *)month andYear:(NSString *)year{

    NSDateComponents *_comps = [[NSDateComponents alloc] init];

    NSInteger dayInter = [day integerValue];
    NSInteger monthInter = [month integerValue];
    NSInteger yearInter = [year integerValue];

    [_comps setDay:dayInter];
    [_comps setMonth:monthInter];
    [_comps setYear:yearInter];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];

    NSString *weak;

    switch (_weekday) {
        case 1:
            weak = @"Sun";
            break;
        case 2:
            weak = @"Mon";
            break;
        case 3:
            weak = @"Tues";
            break;
        case 4:
            weak = @"Wed";
            break;
        case 5:
            weak = @"Thur";
            break;
        case 6:
            weak = @"Fri";
            break;
        case 7:
            weak = @"Sat";
            break;
        default:
            break;
    }

    return weak;
}
@end
