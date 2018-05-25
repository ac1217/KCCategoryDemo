//
//  UIViewController+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/6/7.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "UIViewController+KCExtension.h"
#import "UINavigationBar+KCExtension.h"
#import <objc/runtime.h>

static NSString *const kc_navigationBarBackgroundAlphaKey = @"kc_navigationBarBackgroundAlpha";
static NSString *const kc_navigationBarBackgroundColorKey = @"kc_navigationBarBackgroundColor";
static NSString *const kc_navigationBarTintColorKey = @"kc_navigationBarTintColor";

@implementation UIViewController (KCExtension)

- (void)setKc_navigationBarTintColor:(UIColor *)kc_navigationBarTintColor
{
    
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationBarTintColorKey), kc_navigationBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.navigationController.navigationBar.tintColor = kc_navigationBarTintColor;
}

- (UIColor *)kc_navigationBarTintColor
{
    
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationBarTintColorKey));
}

- (void)setKc_navigationBarBackgroundColor:(UIColor *)kc_navigationBarBackgroundColor
{
    
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationBarBackgroundColorKey), kc_navigationBarBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.navigationController.navigationBar.kc_backgroundColor = kc_navigationBarBackgroundColor;
    
    
}

- (UIColor *)kc_navigationBarBackgroundColor
{
    
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationBarBackgroundColorKey));
}

- (void)setKc_navigationBarBackgroundAlpha:(CGFloat)kc_navigationBarBackgroundAlpha
{
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationBarBackgroundAlphaKey), @(kc_navigationBarBackgroundAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.navigationController.navigationBar.kc_backgroundAlpha = kc_navigationBarBackgroundAlpha;
}

- (CGFloat)kc_navigationBarBackgroundAlpha
{
    id value = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationBarBackgroundAlphaKey));
    
    if (value) {
        
        return [value doubleValue];
    }else {
        return 1;
    }
    
}


+ (instancetype)kc_viewControllerFromStoryboard:(NSString *)sbName
{
  return [self kc_viewControllerFromStoryboard:sbName identifier:NSStringFromClass(self)];
}


+ (instancetype)kc_viewControllerFromStoryboard:(NSString *)sbName identifier:(NSString *)ID
{
    
    return [[UIStoryboard storyboardWithName:sbName bundle:nil] instantiateViewControllerWithIdentifier:ID];
}

@end
