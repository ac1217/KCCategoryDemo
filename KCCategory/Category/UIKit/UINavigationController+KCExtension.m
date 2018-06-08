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
#import <objc/runtime.h>
#import "NSObject+KCExtension.h"


@interface KC_FullscreenInteractivePopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation KC_FullscreenInteractivePopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.kc_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.kc_interactivePopDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    return YES;
}

@end

@implementation UINavigationController (KCTransition)

+ (void)load
{
    
    [self kc_swizzlingInstanceMethod:@selector(kc_updateInteractiveTransition:) otherClass:self otherClassSel:NSSelectorFromString(@"_updateInteractiveTransition:")];
    
    
    [self kc_swizzlingInstanceMethod:@selector(kc_popToViewController:animated:) otherClass:self otherClassSel:@selector(popToViewController:animated:)];
    
    
    [self kc_swizzlingInstanceMethod:@selector(kc_pushViewController:animated:) otherClass:self otherClassSel:@selector(pushViewController:animated:)];

    
    [self kc_swizzlingInstanceMethod:@selector(kc_popViewControllerAnimated:) otherClass:self otherClassSel:@selector(popViewControllerAnimated:)];
    
    [self kc_swizzlingInstanceMethod:@selector(kc_popToRootViewControllerAnimated:) otherClass:self otherClassSel:@selector(popToRootViewControllerAnimated:)];
    
}

- (KC_FullscreenInteractivePopGestureRecognizerDelegate *)kc_interactivePopGestureRecognizerDelegate
{
    KC_FullscreenInteractivePopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[KC_FullscreenInteractivePopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)kc_interactivePopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}


- (void)kc_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.kc_interactivePopGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.kc_interactivePopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.kc_interactivePopGestureRecognizer.delegate = self.kc_interactivePopGestureRecognizerDelegate;
        [self.kc_interactivePopGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self kc_pushViewController:viewController animated:animated];
    
    [self updateNaigationBar];
    
}

- (nullable UIViewController *)kc_popViewControllerAnimated:(BOOL)animated
{
    
    
//    NSLog(@"kc_popViewControllerAnimated");
    UIViewController *vc = [self kc_popViewControllerAnimated:animated];
    
    if (self.topViewController.transitionCoordinator && self.topViewController.transitionCoordinator.initiallyInteractive) {
        
        [self.topViewController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
            
            
            [self handleInteractionChanges:context];
            
        }];
        
        //        return YES;
    }else {
        
        [self updateNaigationBar];
        
    }
    
    return vc;
    
    
}


- (NSArray<__kindof UIViewController *> *)kc_popToRootViewControllerAnimated:(BOOL)animated
{
    
    NSArray *arr = [self kc_popToRootViewControllerAnimated:animated];
    
    [self updateNaigationBar];
    return arr;
}

- (NSArray<__kindof UIViewController *> *)kc_popToViewController:(UIViewController *)vc animated:(BOOL)animated
{
    NSArray *arr = [self kc_popToViewController:vc animated:animated];

    [self updateNaigationBar];
    return arr;

}

- (void)updateNaigationBar
{
    if (self.topViewController.kc_navigationBarHidden) {
        return;
    }
    
    self.navigationBar.kc_backgroundAlpha = self.topViewController.kc_navigationBarBackgroundAlpha;
    self.navigationBar.kc_backgroundColor = self.topViewController.kc_navigationBarBackgroundColor;
    
    self.navigationBar.tintColor = self.topViewController.kc_navigationBarTintColor;
    
}

- (void)kc_updateInteractiveTransition:(CGFloat)percentComplete
{
    
    UIViewController *fromVC =  [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC =  [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (toVC.kc_navigationBarHidden) {
        return;
    }
    
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

/*
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    
    NSLog(@"shouldPopItem");
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
    NSLog(@"shouldPushItem");
    
    navigationBar.kc_backgroundAlpha = self.topViewController.kc_navigationBarBackgroundAlpha;
    navigationBar.kc_backgroundColor = self.topViewController.kc_navigationBarBackgroundColor;
    
    navigationBar.tintColor
    = self.topViewController.kc_navigationBarTintColor;
    
    self.navigationBarHidden = self.topViewController.kc_navigationBarHidden;
    return YES;
}*/


- (void)handleInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    
    if ([context isCancelled]) {// 自动取消了返回手势
        
        NSTimeInterval duration = [context transitionDuration] * (double)[context percentComplete];
        
        UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];

        [UIView animateWithDuration:duration animations:^{

            self.navigationBar.kc_backgroundAlpha = fromVC.kc_navigationBarBackgroundAlpha;
            self.navigationBar.kc_backgroundColor = fromVC.kc_navigationBarBackgroundColor;
            self.navigationBar.tintColor
            = fromVC.kc_navigationBarTintColor;
            
        }];
        
    } else {// 自动完成了返回手势
        NSTimeInterval duration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        
        UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        
        if (toVC.kc_navigationBarHidden) {
            return;
        }
        
        [UIView animateWithDuration:duration animations:^{
            
            
            self.navigationBar.kc_backgroundAlpha = toVC.kc_navigationBarBackgroundAlpha;
            
            self.navigationBar.kc_backgroundColor = toVC.kc_navigationBarBackgroundColor;
            self.navigationBar.tintColor
            = toVC.kc_navigationBarTintColor;
            
        }];
        
    }
    
}

@end
