//
//  UIAlertController+KCExtension.h
//  categoryDemo
//
//  Created by Erica on 2017/11/29.
//  Copyright © 2017年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (KCExtension)

@property (strong,nonatomic) UIColor *kc_attributedTitle;
@property (strong,nonatomic) UIColor *kc_attributedMessage;

- (void)kc_setTitleTextColor:(UIColor *)titleTextColor;
- (void)kc_setMessageTextColor:(UIColor *)messageTextColor;


@end
