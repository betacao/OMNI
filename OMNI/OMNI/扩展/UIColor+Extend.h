//
//  UIColor+Extend.h
//  OMNI
//
//  Created by changxicao on 16/5/15.
//  Copyright © 2016年 changxicao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extend)

// 将十六进制的颜色值转为objective-c的颜色
+ (UIColor *)getColor:(NSString *) hexColor;

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
