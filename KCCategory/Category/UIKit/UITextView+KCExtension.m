//
//  UITextView+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/17.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "UITextView+KCExtension.h"
#import <objc/message.h>
#import "NSObject+KCExtension.h"

static NSString *const KCTextViewPlaceholderLabelKey = @"kc_textViewPlaceholderLabel";
//static NSString *const KCTextViewPlaceholderLabelTopConstraintKey = @"kc_placeholderLabelTopConstraint";
static NSString *const KCTextViewTextVerticalAlignmentKey = @"kc_textVerticalAlignment";

static NSString *const KCTextViewMaxLengthKey = @"kc_textViewMaxLength";
static NSString *const KCTextViewDidEditToMaxLengthBlockKey = @"kc_textViewDidEditToMaxLengthBlock";

@interface UITextView ()
@property (nonatomic, strong) UILabel *kc_placeholderLabel;
//@property (nonatomic, strong) NSLayoutConstraint *kc_placeholderLabelTopConstraint;
@end

@implementation UITextView (KCExtension)

- (UILabel *)kc_placeholderLabel
{
    UILabel *placeholderLabel = objc_getAssociatedObject(self, (__bridge const void *)(KCTextViewPlaceholderLabelKey));
    if (!placeholderLabel) {
        placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.font = self.font;
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.textAlignment = self.textAlignment;
        [self addSubview:placeholderLabel];
        objc_setAssociatedObject(self, (__bridge const void *)(KCTextViewPlaceholderLabelKey), placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        CGFloat H = self.textContainer.lineFragmentPadding + self.textContainerInset.left;
        CGFloat V = self.textContainerInset.top;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:H]];
        
        NSLayoutConstraint *topCons = [NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:V];
        
        [self addConstraint:topCons];
        //
        [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:H * -2]];
        
    }
    
    return placeholderLabel;
    
}

+ (void)load
{
    //    Class cls = [self class];
    
    [self kc_swizzlingInstanceMethod:NSSelectorFromString(@"dealloc") otherSel:@selector(kc_dealloc)];
    
    [self kc_swizzlingInstanceMethod:@selector(kc_setFont:) otherSel:@selector(setFont:)];
    
    [self kc_swizzlingInstanceMethod:@selector(setText:) otherSel:@selector(kc_setText:)];
    
    [self kc_swizzlingInstanceMethod:@selector(setAttributedText:) otherSel:@selector(kc_setAttributedText:)];
    
    [self kc_swizzlingInstanceMethod:@selector(setTextAlignment:) otherSel:@selector(kc_setTextAlignment:)];
}

- (void)kc_addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kc_textViewTextChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)kc_removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)kc_dealloc
{
    [self kc_dealloc];
    
    [self kc_removeObserver];
}

- (void)kc_setAttributedText:(NSAttributedString *)attrText
{
    [self kc_setAttributedText:attrText];
    
    [self kc_removeObserver];
    
    [self kc_addObserver];
    
    [self kc_textViewTextChange];
    [self setNeedsLayout];
}

- (void)kc_setTextAlignment:(NSTextAlignment)textAlignment
{
    [self kc_setTextAlignment:textAlignment];
    
    self.kc_placeholderLabel.textAlignment = textAlignment;
}


- (void)kc_setText:(NSString *)text
{
    [self kc_setText:text];
    
    [self kc_removeObserver];
    
    [self kc_addObserver];
    [self kc_textViewTextChange];
    [self setNeedsLayout];
}

- (void)kc_setFont:(UIFont *)font
{
    [self kc_setFont:font];
    
    self.kc_placeholderLabel.font = font;
    
    [self kc_removeObserver];
    
    [self kc_addObserver];
    
    [self kc_textViewTextChange];
    [self setNeedsLayout];
    
}

- (void)setKc_placeholder:(NSString *)kc_placeholder
{
    
    self.kc_placeholderLabel.text = kc_placeholder;
    
}

- (void)setKc_placeholderAttributedString:(NSAttributedString *)kc_placeholderAttributedString
{
    self.kc_placeholderLabel.attributedText = kc_placeholderAttributedString;
}

- (NSAttributedString *)kc_placeholderAttributedString
{
    return self.kc_placeholderLabel.attributedText;
}

- (NSString *)kc_placeholder
{
    return self.kc_placeholderLabel.text;
}

- (void)setKc_placeholderColor:(UIColor *)kc_placeholderColor
{
    [self.kc_placeholderLabel setTextColor:kc_placeholderColor];
}

- (UIColor *)kc_placeholderColor
{
    return [self.kc_placeholderLabel textColor];
}

- (void)setKc_textVerticalAlignment:(KCTextVerticalAlignment)kc_textVerticalAlignment
{
    
    objc_setAssociatedObject(self, (__bridge const void *)(KCTextViewTextVerticalAlignmentKey), @(kc_textVerticalAlignment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self kc_removeObserver];
    
    [self kc_addObserver];
    
    [self kc_textViewTextChange];
    
    [self setNeedsLayout];
}

- (KCTextVerticalAlignment)kc_textVerticalAlignment
{
    return [objc_getAssociatedObject(self, (__bridge const void *)(KCTextViewTextVerticalAlignmentKey)) integerValue];
    
}


- (void)setKc_maxLength:(NSInteger)kc_maxLength
{
    //    [self addTarget:self action:@selector(kc_textFieldTextChange) forControlEvents:UIControlEventEditingChanged];
    
    objc_setAssociatedObject(self, (__bridge const void *)(KCTextViewMaxLengthKey), @(kc_maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setKc_textViewDidEditToMaxLengthBlock:(void (^)(UITextView *))kc_textViewDidEditToMaxLengthBlock
{
    
    objc_setAssociatedObject(self, (__bridge const void *)(KCTextViewDidEditToMaxLengthBlockKey), kc_textViewDidEditToMaxLengthBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITextView *))kc_textViewDidEditToMaxLengthBlock
{
    return objc_getAssociatedObject(self, (__bridge const void *)(KCTextViewDidEditToMaxLengthBlockKey));
}

- (void)kc_textViewTextChange
{
    switch (self.kc_textVerticalAlignment) {
        case KCTextVerticalAlignmentCenter:
        {
            
            CGSize contentSize = self.contentSize;
            UIEdgeInsets contentInset = self.contentInset;
            
            if (contentSize.height <= self.frame.size.height) {
                
                CGFloat offsetY = (self.frame.size.height - contentSize.height) * 0.5;
                
                contentInset.top = offsetY;
                
            }else {
                
                contentInset.top = 0;
            }
            
            self.contentInset = contentInset;
            
        }
            break;
        case KCTextVerticalAlignmentBottom :
        {
            
            CGSize contentSize = self.contentSize;
            UIEdgeInsets contentInset = self.contentInset;
            
            if (contentSize.height <= self.frame.size.height) {
                
                CGFloat offsetY = self.frame.size.height - contentSize.height;
                
                contentInset.top = offsetY;
                
                
            }else {
                
                contentInset.top = 0;
            }
            
            self.contentInset = contentInset;
            
        }
            break;
            
        default:{
            UIEdgeInsets contentInset = self.contentInset;
            contentInset.top = 0;
        }
            break;
    }
    
    
    self.kc_placeholderLabel.hidden = self.hasText;
    
    if (!self.kc_maxLength) {
        return;
    }
    
    if (self.text.length > self.kc_maxLength || self.attributedText.length > self.kc_maxLength) {
        [self deleteBackward];
        !self.kc_textViewDidEditToMaxLengthBlock ? : self.kc_textViewDidEditToMaxLengthBlock(self);
    }
    
    
    
}

- (NSInteger)kc_maxLength
{
    return [objc_getAssociatedObject(self, (__bridge const void *)(KCTextViewMaxLengthKey)) integerValue];
}

@end

