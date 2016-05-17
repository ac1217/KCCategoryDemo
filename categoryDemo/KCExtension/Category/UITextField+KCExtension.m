//
//  UITextField+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/17.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "UITextField+KCExtension.h"

@implementation UITextField (KCExtension)

- (void)setKc_placeholderColor:(UIColor *)kc_placeholderColor
{
    [[self valueForKeyPath:@"placeholderLabel"] setTextColor:kc_placeholderColor];
}

- (UIColor *)kc_placeholderColor
{
    return [[self valueForKeyPath:@"placeholderLabel"] textColor];
}

@end
