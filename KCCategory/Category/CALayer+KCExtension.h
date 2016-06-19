//
//  CALayer+KCExtension.h
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/17.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CALayer (KCExtension)


// 增加圆角遮盖
- (void)kc_setRoundedCoverWithBackgroundColor:(CGColorRef)color cornerRadius:(CGFloat)radius;
@end
