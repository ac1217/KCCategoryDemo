//
//  UIViewController+KCExtension.h
//  categoryDemo
//
//  Created by zhangweiwei on 16/6/7.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KCExtension)

@property (nonatomic, assign) CGFloat kc_navgationBarBackgroundAlpha;
@property (nonatomic, assign) BOOL kc_navgationBarBackgroundHidden;


- (void)kc_setNavigationBarBackgroundHidden:(BOOL)hidden animate:(BOOL)animate;

@end
