//
//  UIViewController+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/6/7.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "UIViewController+KCExtension.h"
#import <objc/runtime.h>
#import "NSObject+KCExtension.h"

static NSString *const kc_navigationInteractivePushBlockKey = @"kc_navigationInteractivePushBlockKey";

@implementation UIViewController (KCExtension)

- (void)setKc_navigationInteractivePushBlock:(void (^)(UIViewController *, UIPanGestureRecognizer *))kc_navigationInteractivePushBlock
{
    
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationInteractivePushBlockKey), kc_navigationInteractivePushBlock, OBJC_ASSOCIATION_COPY);
    
//    self.navigationController.navigationBar.tintColor = kc_navigationBarTintColor;
}


- (void (^)(UIViewController *, UIPanGestureRecognizer *))kc_navigationInteractivePushBlock
{
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kc_navigationInteractivePushBlockKey));
}

- (BOOL)kc_navigationInteractivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setKc_navigationInteractivePopDisabled:(BOOL)kc_navigationInteractivePopDisabled
{
    objc_setAssociatedObject(self, @selector(kc_navigationInteractivePopDisabled), @(kc_navigationInteractivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)kc_navigationInteractivePopDistanceToLeftEdge
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
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
