//
//  UINavigationController+KCTransition.m
//  KCNavigationTransition
//
//  Created by Erica on 2018/5/7.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "UINavigationController+KCExtension.h"
#import "UIViewController+KCExtension.h"
#import <objc/runtime.h>
#import "NSObject+KCExtension.h"
#import "UIView+KCExtension.h"

@interface KC_FullscreenInteractiveGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation KC_FullscreenInteractiveGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];

    if (translation.x > 0) { // pop
        
        if (self.navigationController.viewControllers.count <= 1 || topViewController.kc_navigationInteractivePopDisabled) {
            return NO;
        }
        
        CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
        CGFloat maxAllowedInitialDistance = topViewController.kc_navigationInteractivePopDistanceToLeftEdge;
        if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
            return NO;
        }
        NSArray *internalTargets = [self.navigationController.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        
        [gestureRecognizer removeTarget:self action:internalAction];
        [gestureRecognizer addTarget:internalTarget action:internalAction];
       
        
    }else { // push
        
        if (!topViewController.kc_navigationInteractivePushBlock) {
            
            return NO;
        }
        
        NSArray *internalTargets = [self.navigationController.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        [gestureRecognizer removeTarget:internalTarget action:internalAction];
        [gestureRecognizer addTarget:self action:internalAction];
        
    }
    
    return YES;
}

- (UIPercentDrivenInteractiveTransition *)interactivePopTransition{
    if (!_interactivePopTransition) {
        _interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        _interactivePopTransition.completionCurve = UIViewAnimationCurveEaseOut;
    }
    return _interactivePopTransition;
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    CGFloat progress = translation.x / gestureRecognizer.view.bounds.size.width;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan && translation.x < 0 && self.navigationController.topViewController.kc_navigationInteractivePushBlock) {
        
        self.navigationController.delegate = self;
        
        self.navigationController.topViewController.kc_navigationInteractivePushBlock(self.navigationController.topViewController, gestureRecognizer);
        
        [self.interactivePopTransition updateInteractiveTransition:progress];
        
    }else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        if (!self.navigationController.delegate) {
            return;
        }
        
        if (progress <= 0) {
            progress = fabs(progress);
            progress = MIN(1.0, MAX(0.0, progress));
        }
        else{
            progress = 0;
        }
        
        [self.interactivePopTransition updateInteractiveTransition:progress];
        
        
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        
        if (!self.navigationController.delegate) {
            return;
        }
        
        CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view];
        
        if (velocity.x < -100 || fabs(progress) > 0.25) {
            
            [self.interactivePopTransition finishInteractiveTransition];
            
        }else {
            
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.navigationController.delegate = nil;
        
    }
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationControxller
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    
    // return custom animation transition for given situtation.
    if (operation == UINavigationControllerOperationPush) {
        return self;
    }
    
    return nil;
}


- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    
    return self.interactivePopTransition;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toVC.view.frame = CGRectMake(containerView.frame.size.width, 0, containerView.frame.size.width, containerView.frame.size.height);
    
    fromVC.view.frame = [transitionContext initialFrameForViewController:fromVC];
    
    
    UIImageView *tabBarView;
    UITabBar *tabBar;
    if (toVC.hidesBottomBarWhenPushed) {
        
        tabBar = fromVC.tabBarController.tabBar;
        
        UIImage *image = tabBar.kc_screenshot;
        tabBarView = [[UIImageView alloc] initWithImage:image];
        CGRect imgFrame = tabBarView.frame;
        imgFrame.origin.x = fromVC.view.frame.origin.x;
        imgFrame.origin.y = containerView.frame.size.height - imgFrame.size.height;
        tabBarView.frame = imgFrame;
        [containerView addSubview:tabBarView];
        tabBar.hidden = YES;
        
    }
    
    
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGRect fromViewFrame = fromVC.view.frame;
        fromViewFrame.origin.x = -0.3 * fromViewFrame.size.width;
        fromVC.view.frame = fromViewFrame;
        
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        
        CGRect imgFrame = tabBarView.frame;
        imgFrame.origin.x = fromViewFrame.origin.x;
        tabBarView.frame = imgFrame;
        
    } completion:^(BOOL finished) {
        
        BOOL cancel = transitionContext.transitionWasCancelled;
        
        [transitionContext completeTransition:!cancel];
        
        if (cancel) {
            
            [toVC.view removeFromSuperview];
        }else {
            [fromVC.view removeFromSuperview];
        }
        
        [tabBarView removeFromSuperview];
//        tabBar.hidden = NO;
        
        
    }];
    
}

@end

@implementation UINavigationController (KCExtension)


- (KC_FullscreenInteractiveGestureRecognizerDelegate *)kc_interactivePopGestureRecognizerDelegate
{
    KC_FullscreenInteractiveGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[KC_FullscreenInteractiveGestureRecognizerDelegate alloc] init];
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
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:panGestureRecognizer];
        
        panGestureRecognizer.delegate = self.kc_interactivePopGestureRecognizerDelegate;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (void)setKc_fullscreenInteractivePopGestureRecognizerEnabled:(BOOL)kc_fullscreenInteractivePopGestureRecognizerEnabled
{
    self.kc_interactivePopGestureRecognizer.enabled = kc_fullscreenInteractivePopGestureRecognizerEnabled;
    
    self.interactivePopGestureRecognizer.enabled = !kc_fullscreenInteractivePopGestureRecognizerEnabled;
    
}

- (BOOL)kc_fullscreenInteractivePopGestureRecognizerEnabled
{
    return self.kc_interactivePopGestureRecognizer.isEnabled;
}



@end
