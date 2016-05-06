//
//  NSDate+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/6.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "NSDate+KCExtension.h"

@implementation NSDate (KCExtension)

+ (NSString *)kc_dateStringWithTimeInterval:(NSTimeInterval)time formatter:(NSString *)fmt
{
    return [[NSDate dateWithTimeIntervalSince1970:time] kc_dateStringWithFormatter:fmt];
}

- (NSString *)kc_dateStringWithFormatter:(NSString *)fmt
{
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = fmt;
    return [dateFmt stringFromDate:self];
}

@end
