//
//  UITextView+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/17.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "UITextView+KCExtension.h"
#import <objc/message.h>

@implementation UITextView (KCExtension)

+ (void)load
{
    Method dealloc1 = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method dealloc2 = class_getInstanceMethod(self, @selector(kc_dealloc));
    
    method_exchangeImplementations(dealloc1 , dealloc2);
    
    Method font1 = class_getInstanceMethod(self, @selector(setFont:));
    Method font2 = class_getInstanceMethod(self, @selector(kc_setFont:));
    
    method_exchangeImplementations(font1 , font2);
    
    Method text1 = class_getInstanceMethod(self, @selector(setText:));
    Method text2 = class_getInstanceMethod(self, @selector(kc_setText:));
    
    method_exchangeImplementations(text1 , text2);
    
    
    Method attrText1 = class_getInstanceMethod(self, @selector(setAttributedText:));
    Method attrText2 = class_getInstanceMethod(self, @selector(kc_setAttributedText:));
    
    method_exchangeImplementations(attrText1 , attrText2);
}

- (void)kc_dealloc
{
    [self kc_dealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)kc_setAttributedText:(NSAttributedString *)attrText
{
    [self kc_setAttributedText:attrText];
    
    [self kc_textChange];
}

- (void)kc_setText:(NSString *)text
{
    [self kc_setText:text];
    
    [self kc_textChange];
}

- (void)kc_setFont:(UIFont *)font
{
    [self kc_setFont:font];
    
    UILabel *placeholderLabel = objc_getAssociatedObject(self, @"kc_placeholderLabel");
    placeholderLabel.font = font;
    
}

- (void)setKc_placeholder:(NSString *)kc_placeholder
{
     UILabel *placeholderLabel = objc_getAssociatedObject(self, @"kc_placeholderLabel");
    
    if (!placeholderLabel) {
        placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.font = self.font;
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        placeholderLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:placeholderLabel];
        objc_setAssociatedObject(self, @"kc_placeholderLabel", placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        CGFloat H = 5;
        CGFloat V = 8;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:H]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:V]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:H]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kc_textChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    placeholderLabel.text = kc_placeholder;

}

- (void)kc_textChange
{
    
    UILabel *placeholderLabel = objc_getAssociatedObject(self, @"kc_placeholderLabel");
    
    placeholderLabel.hidden = self.hasText;
}

- (NSString *)kc_placeholder
{
    UILabel *placeholderLabel = objc_getAssociatedObject(self, @"kc_placeholderLabel");
    return placeholderLabel.text;
}

@end
