//
//  UIAlertController+KCExtension.m
//  categoryDemo
//
//  Created by Erica on 2017/11/29.
//  Copyright © 2017年 Erica. All rights reserved.
//

#import "UIAlertController+KCExtension.h"

@implementation UIAlertController (KCExtension)

- (void)kc_setTitleTextColor:(UIColor *)titleTextColor
{
    NSAttributedString *titleArrt = [[NSAttributedString alloc] initWithString:self.title attributes:@{NSForegroundColorAttributeName : titleTextColor, NSFontAttributeName : [UIFont boldSystemFontOfSize:14]}];
    self.kc_attributedTitle = titleArrt;
}


- (void)kc_setMessageTextColor:(UIColor *)messageTextColor
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.message attributes:@{NSForegroundColorAttributeName:messageTextColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
    self.kc_attributedMessage = attr;
}

- (void)setKc_attributedTitle:(NSAttributedString *)kc_attributedTitle
{
    
    [self setValue:kc_attributedTitle forKey:@"attributedTitle"];
}

- (NSAttributedString *)kc_attributedTitle
{
    return [self valueForKey:@"attributedTitle"];
}

- (void)setKc_attributedMessage:(NSAttributedString *)kc_attributedMessage
{
    
    [self setValue:kc_attributedMessage forKey:@"attributedMessage"];
}

- (NSAttributedString *)kc_attributedMessage
{
    return [self valueForKey:@"attributedMessage"];
}

@end
