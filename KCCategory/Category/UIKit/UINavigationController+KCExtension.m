//
//  UINavigationController+KCTransition.m
//  KCNavigationTransition
//
//  Created by Erica on 2018/5/7.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "UINavigationController+KCExtension.h"
#import "UIViewController+KCExtension.h"
#import "UINavigationBar+KCExtension.h"
//#import <objc/runtime.h>
#import "NSObject+KCExtension.h"

@implementation UINavigationController (KCTransition)

+ (void)load
{
    
    [self kc_swizzlingInstanceMethod:@selector(kc_updateInteractiveTransition:) otherClass:self otherClassSel:NSSelectorFromString(@"_updateInteractiveTransition:")];
    
    
    [self kc_swizzlingInstanceMethod:@selector(kc_popToViewController:animated:) otherClass:self otherClassSel:@selector(popToViewController:animated:)];

    
    
    [self kc_swizzlingInstanceMethod:@selector(kc_popToRootViewControllerAnimated:) otherClass:self otherClassSel:@selector(popToRootViewControllerAnimated:)];
    
}

- (NSArray<__kindof UIViewController *> *)kc_popToRootViewControllerAnimated:(BOOL)animated
{
    
    NSArray *arr = [self kc_popToRootViewControllerAnimated:animated];
    
//    UIViewController *vc = self.viewControllers.firstObject;

    self.navigationBar.kc_backgroundAlpha = self.topViewController.kc_navigationBarBackgroundAlpha;
    self.navigationBar.kc_backgroundColor = self.topViewController.kc_navigationBarBackgroundColor;

    self.navigationBar.tintColor = self.topViewController.kc_navigationBarTintColor;
    return arr;
}

- (NSArray<__kindof UIViewController *> *)kc_popToViewController:(UIViewController *)vc animated:(BOOL)animated
{
    NSArray *arr = [self kc_popToViewController:vc animated:animated];
    self.navigationBar.kc_backgroundAlpha = self.topViewController.kc_navigationBarBackgroundAlpha;
    self.navigationBar.kc_backgroundColor = self.topViewController.kc_navigationBarBackgroundColor;

    self.navigationBar.tintColor = self.topViewController.kc_navigationBarTintColor;


    return arr;

}

- (void)kc_updateInteractiveTransition:(CGFloat)percentComplete
{
    
    UIViewController *fromVC =  [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC =  [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat fromAlpha = fromVC.kc_navigationBarBackgroundAlpha;
    CGFloat toAlpha = toVC.kc_navigationBarBackgroundAlpha;
    
    CGFloat alpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
    
    self.navigationBar.kc_backgroundAlpha = alpha;
    
    UIColor *fromColor = fromVC.kc_navigationBarBackgroundColor;
    UIColor *toColor = toVC.kc_navigationBarBackgroundColor;
    
    self.navigationBar.kc_backgroundColor = [self kc_transitionFromColor:fromColor toColor:toColor percent:percentComplete];
    
    UIColor *fromTintColor = fromVC.kc_navigationBarTintColor;
    UIColor *toTintColor = toVC.kc_navigationBarTintColor;
    
    self.navigationBar.tintColor = [self kc_transitionFromColor:fromTintColor toColor:toTintColor percent:percentComplete];
    
    [self kc_updateInteractiveTransition:percentComplete];
    
    
    
    
}

- (UIColor *)kc_transitionFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat fromR = 0;
    CGFloat fromG = 0;
    CGFloat fromB = 0;
    CGFloat fromA = 0;
    
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromA];
    
    CGFloat toR = 0;
    CGFloat toG = 0;
    CGFloat toB = 0;
    CGFloat toA = 0;
    
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toA];
    
    CGFloat R = fromR + (toR - fromR) * percent;
    CGFloat G = fromG + (toG - fromG) * percent;
    CGFloat B = fromB + (toB - fromB) * percent;
    CGFloat A = fromA + (toA - fromA) * percent;
    
    return [UIColor colorWithRed:R green:G blue:B alpha:A];
}


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    
//    if (self.topViewController.transitionCoordinator) {
    
    if (self.topViewController.transitionCoordinator && self.topViewController.transitionCoordinator.initiallyInteractive) {
        
        [self.topViewController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
            
            
            [self handleInteractionChanges:context];
            
        }];
        
        return YES;
    }
    
    NSInteger count = (self.viewControllers.count >= self.navigationBar.items.count) ? 2 : 1;
    
    UIViewController *vc = self.viewControllers[self.viewControllers.count - count];
    [self popToViewController:vc animated:YES];
    
    return YES;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    
    navigationBar.kc_backgroundAlpha = self.topViewController.kc_navigationBarBackgroundAlpha;
    navigationBar.kc_backgroundColor = self.topViewController.kc_navigationBarBackgroundColor;
    
    navigationBar.tintColor
    = self.topViewController.kc_navigationBarTintColor;
    
    return YES;
}


- (void)handleInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    
    if ([context isCancelled]) {// 自动取消了返回手势
        
        NSTimeInterval duration = [context transitionDuration] * (double)[context percentComplete];
        
        [UIView animateWithDuration:duration animations:^{

            UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];

            self.navigationBar.kc_backgroundAlpha = fromVC.kc_navigationBarBackgroundAlpha;
            self.navigationBar.kc_backgroundColor = fromVC.kc_navigationBarBackgroundColor;
            self.navigationBar.tintColor
            = fromVC.kc_navigationBarTintColor;
            
        }];
        
    } else {// 自动完成了返回手势
        NSTimeInterval duration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        
        [UIView animateWithDuration:duration animations:^{
            
            
            UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
            
            self.navigationBar.kc_backgroundAlpha = toVC.kc_navigationBarBackgroundAlpha;
            
            self.navigationBar.kc_backgroundColor = toVC.kc_navigationBarBackgroundColor;
            self.navigationBar.tintColor
            = toVC.kc_navigationBarTintColor;
            
        }];
    }
}

@end
