//
//  UINavigationBar+KCTransition.m
//  KCNavigationTransition
//
//  Created by Erica on 2018/5/7.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "UINavigationBar+KCExtension.h"
#import <objc/runtime.h>

static NSString *const kc_backgroundViewKey = @"kc_backgroundView";

@implementation UINavigationBar (KCTransition)

- (UIView *)kc_backgroundView
{
    UIView *view = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kc_backgroundViewKey));
    
//    UIView *backgroundView = [self valueForKey:@"backgroundView"];
    //    view.frame = backgroundView.frame;
//    [backgroundView bringSubviewToFront:view];
    
    return view;
    
}

- (void)kc_addBackgroundView
{
    UIView *view = [UIView new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *backgroundView = [self valueForKey:@"backgroundView"];
    [backgroundView addSubview:view];
    
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kc_backgroundViewKey), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (void)setKc_backgroundAlpha:(CGFloat)kc_backgroundAlpha
{
    UIView *backgroundView = [self valueForKey:@"_backgroundView"];
    
    UIView *shadowView = [backgroundView valueForKey:@"_shadowView"];
    shadowView.alpha = kc_backgroundAlpha;
    shadowView.hidden = kc_backgroundAlpha == 0;
    
    [self kc_backgroundView].alpha = kc_backgroundAlpha;
    
    if (self.isTranslucent) {
        
        if (@available(iOS 10.0, *)) {
            
            if (![self backgroundImageForBarMetrics:UIBarMetricsDefault]) {
                
                UIView *backgroundEffectView = [backgroundView valueForKey:@"_backgroundEffectView"];
                
                backgroundEffectView.alpha = kc_backgroundAlpha;
                backgroundEffectView.hidden = kc_backgroundAlpha == 0;
                
                return;
                
            }else {
                
                UIView *backgroundImageView = [backgroundView valueForKey:@"_backgroundImageView"];
                
                backgroundImageView.alpha = kc_backgroundAlpha;
                backgroundImageView.hidden = kc_backgroundAlpha == 0;
                
                return;
            }
            
        }else {
            
            UIView *adaptiveBackdrop = [backgroundView valueForKey:@"_adaptiveBackdrop"];
            UIView *backdropEffectView = [adaptiveBackdrop valueForKey:@"_backdropEffectView"];
            backdropEffectView.alpha = kc_backgroundAlpha;
            backdropEffectView.hidden = kc_backgroundAlpha == 0;
            
            return;
            
        }
        
    }
    
    backgroundView.alpha = kc_backgroundAlpha;
    backgroundView.hidden = kc_backgroundAlpha == 0;
    
}

- (CGFloat)kc_backgroundAlpha
{
    UIView *backgroundView = [self valueForKey:@"_backgroundView"];
    return backgroundView.alpha;
}

- (void)setKc_backgroundColor:(UIColor *)kc_backgroundColor
{
    
    if (![self kc_backgroundView]) {
        [self kc_addBackgroundView];
    }
    
    [self kc_backgroundView].backgroundColor = kc_backgroundColor;
}

- (UIColor *)kc_backgroundColor
{
    return [self kc_backgroundView].backgroundColor;
}

@end
