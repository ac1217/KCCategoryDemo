//
//  NSDate+KCExtension.h
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/6.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KCExtension)

// 通过时间戳获取日期字符串
+ (NSString *)kc_dateStringWithTimeInterval:(NSTimeInterval)time formatter:(NSString *)fmt;
// 获取时间字符串
- (NSString *)kc_dateStringWithFormatter:(NSString *)fmt;

@end
