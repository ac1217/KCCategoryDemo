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
#import "NSObject+KCExtension.h"

static NSString *const kc_navigationBarBackgroundAlphaKey = @"kc_navigationBarBackgroundAlpha";
static NSString *const kc_navigationBarBackgroundColorKey = @"kc_navigationBarBackgroundColor";
static NSString *const kc_navigationBarTintColorKey = @"kc_navigationBarTintColor";
static NSString *const kc_navigationBarHiddenKey = @"kc_navigationBarHidden";
static NSString *const kc_navigationInteractivePushBlockKey = @"kc_navigationInteractivePushBlockKey";

@implementation UIViewController (KCExtension)

+ (void)load
{
   
    [self kc_swizzlingInstanceMethod:@selector(kc_viewWillAppear:) otherClass:self otherClassSel:@selector(viewWillAppear:)];
    [self kc_swizzlingInstanceMethod:@selector(kc_viewWillDisappear:) otherClass:self otherClassSel:@selector(viewWillDisappear:)];
    
}

- (void)kc_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    [self kc_viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.kc_navigationBarHidden animated:animated];
//    [self.navigationController setNavigationBarHidden:viewController.fd_prefersNavigationBarHidden animated:animated];
//    if (self.fd_willAppearInjectBlock) {
//        self.fd_willAppearInjectBlock(self, animated);
//    }
}

- (void)kc_viewWillDisappear:(BOOL)animated
{
    // Forward to primary implementation.
    [self kc_viewWillDisappear:animated];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *viewController = self.navigationController.viewControllers.lastObject;
    
        if (viewController && !viewController.kc_navigationBarHidden) {
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
//    });
}

- (void)setKc_navigationInteractivePushBlock:(void (^)(UIViewController *, UIPanGestureRecognizer *))kc_navigationInteractivePushBlock
{
    
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationInteractivePushBlockKey), kc_navigationInteractivePushBlock, OBJC_ASSOCIATION_COPY);
    
//    self.navigationController.navigationBar.tintColor = kc_navigationBarTintColor;
}


- (void (^)(UIViewController *, UIPanGestureRecognizer *))kc_navigationInteractivePushBlock
{
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationInteractivePushBlockKey));
}

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

- (BOOL)kc_navigationInteractivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKc_navigationInteractivePopDisabled:(BOOL)kc_navigationInteractivePopDisabled
{
    objc_setAssociatedObject(self, @selector(kc_navigationInteractivePopDisabled), @(kc_navigationInteractivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setKc_navigationBarHidden:(BOOL)kc_navigationBarHidden
{
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationBarHiddenKey), @(kc_navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.navigationController.navigationBarHidden = kc_navigationBarHidden;
}

- (BOOL)kc_navigationBarHidden
{
    id value = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationBarHiddenKey));
    
    return [value boolValue];
    
}


- (CGFloat)kc_navigationInteractivePopDistanceToLeftEdge
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setKc_navigationInteractivePopDistanceToLeftEdge:(CGFloat)kc_interactivePopDistanceToLeftEdge
{
    SEL key = @selector(kc_navigationInteractivePopDistanceToLeftEdge);
    objc_setAssociatedObject(self, key, @(MAX(0, kc_interactivePopDistanceToLeftEdge)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
