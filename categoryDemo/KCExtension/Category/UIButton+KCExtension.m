//
//  UIButton+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/6.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "UIButton+KCExtension.h"
#import <objc/runtime.h>
#import "UIView+KCExtension.h"

@interface UIButton ()

@property (nonatomic, strong) UILabel *kc_badgeLabel;

@end

@implementation UIButton (KCExtension)

#pragma mark -下标相关
- (void)setKc_badgeLabel:(UILabel *)kc_badgeLabel {
    objc_setAssociatedObject(self, @selector(kc_badgeLabel), kc_badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)kc_badgeLabel {
    
    UILabel *kc_badgeLabel = objc_getAssociatedObject(self, @selector(kc_badgeLabel));
    
    if (!kc_badgeLabel) {
        kc_badgeLabel = [[UILabel alloc] init];
        kc_badgeLabel.backgroundColor = [UIColor redColor];
        kc_badgeLabel.textAlignment = NSTextAlignmentCenter;
        kc_badgeLabel.textColor = [UIColor whiteColor];
        kc_badgeLabel.font = [UIFont systemFontOfSize:9];
        kc_badgeLabel.layer.cornerRadius = 5;
        kc_badgeLabel.clipsToBounds = YES;
        [self addSubview:kc_badgeLabel];
        self.kc_badgeLabel = kc_badgeLabel;

    }
    
    return kc_badgeLabel;
}

- (void)setKc_badgeValue:(NSString *)kc_badgeValue
{
    self.kc_badgeLabel.hidden = !kc_badgeValue;
    
    if (kc_badgeValue) {
        self.kc_badgeLabel.text = kc_badgeValue;
        
    }
}

- (NSString *)kc_badgeValue
{
    return self.kc_badgeLabel.text;
}

- (BOOL)isRedDotTip
{
    return !self.kc_badgeLabel.hidden;
}

- (void)setRedDotTip:(BOOL)redDotTip
{
    self.kc_badgeLabel.hidden = !redDotTip;
    
    if (redDotTip) {
        self.kc_badgeValue = @"";
        
    }
}


@end
