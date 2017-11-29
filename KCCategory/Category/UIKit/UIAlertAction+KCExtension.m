//
//  UIAlertAction+KCExtension.m
//  categoryDemo
//
//  Created by Erica on 2017/11/29.
//  Copyright © 2017年 Erica. All rights reserved.
//

#import "UIAlertAction+KCExtension.h"

@implementation UIAlertAction (KCExtension)

- (void)setKc_textColor:(UIColor *)kc_textColor
{
    [self setValue:kc_textColor forKey:@"titleTextColor"];
}

- (UIColor *)kc_textColor
{
    return [self valueForKey:@"titleTextColor"];
}
@end
