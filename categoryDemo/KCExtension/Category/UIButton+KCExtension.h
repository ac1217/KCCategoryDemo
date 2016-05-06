//
//  UIButton+KCExtension.h
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/6.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (KCExtension)
/*
 * 下标
 */

// 数字提示
@property (nonatomic, copy) NSString *kc_badgeValue;
// 红点提示
@property (nonatomic, assign, getter=isRedDotTip) BOOL redDotTip;


@end
