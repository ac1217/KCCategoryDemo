//
//  UITextField+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/17.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "UITextField+KCExtension.h"
#import <objc/runtime.h>

static NSString *const KCTextFieldPlaceholderLabelKey = @"kc_textFieldPlaceholderLabel";

static NSString *const KCTextFieldMaxLengthKey = @"kc_textFieldMaxLength";

@implementation UITextField (KCExtension)

- (void)setKc_maxLength:(NSInteger)kc_maxLength
{
    [self addTarget:self action:@selector(kc_textFieldTextChange) forControlEvents:UIControlEventEditingChanged];
    
    objc_setAssociatedObject(self, (__bridge const void *)(KCTextFieldMaxLengthKey), @(kc_maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)kc_textFieldTextChange
{
    if (!self.kc_maxLength) {
        return;
    }
    
    if (self.text.length > self.kc_maxLength || self.attributedText.length > self.kc_maxLength) {
        [self deleteBackward];
    }
}

- (NSInteger)kc_maxLength
{
    return [objc_getAssociatedObject(self, (__bridge const void *)(KCTextFieldMaxLengthKey)) integerValue];
}

- (void)setKc_placeholderColor:(UIColor *)kc_placeholderColor
{
    [[self valueForKeyPath:KCTextFieldPlaceholderLabelKey] setTextColor:kc_placeholderColor];
}

- (UIColor *)kc_placeholderColor
{
    return [[self valueForKeyPath:KCTextFieldPlaceholderLabelKey] textColor];
}

@end
