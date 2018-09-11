//
//  NSAttributedString+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 2016/10/12.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "NSAttributedString+KCExtension.h"

@implementation NSAttributedString (KCExtension)


+ (instancetype)kc_attributedStringWithString:(NSString *)string font:(UIFont *)font textColor:(UIColor *)textColor
{
    
    if (!font) {
        NSLog(@"font 不能为nil");
        return nil;
    }
    
    if (!textColor) {
        NSLog(@"textColor 不能为nil");
        return nil;
    }
    
    return [[self alloc] initWithString:string attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName: textColor}];
    
}

+ (instancetype)kc_attributedStringWithString:(NSString *)string font:(UIFont *)font
{
    if (!font) {
        NSLog(@"font 不能为nil");
        return nil;
    }
    
    return [[self alloc] initWithString:string attributes:@{NSFontAttributeName : font}];
}

+ (instancetype)kc_attributedStringWithString:(NSString *)string textColor:(UIColor *)textColor
{
    
    if (!textColor) {
        NSLog(@"textColor 不能为nil");
        return nil;
    }
    
    return [[self alloc] initWithString:string attributes:@{ NSForegroundColorAttributeName: textColor}];
}


@end
