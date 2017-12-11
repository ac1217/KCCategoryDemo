//
//  NSObject+KCExtension.m
//  categoryDemo
//
//  Created by Erica on 2017/12/6.
//  Copyright © 2017年 Erica. All rights reserved.
//

#import "NSObject+KCExtension.h"
#import <objc/runtime.h>

@implementation NSObject (KCExtension)

+ (void)kc_swizzlingInstanceMethod:(Class)firstClass firstClassSel:(SEL)firstClassSel secondClass:(Class)secondClass secondClassSel:(SEL)secondClassSel
{
    
    Method firstMethod = class_getInstanceMethod(firstClass, firstClassSel);
    
    Method secondMethod = class_getInstanceMethod(secondClass, secondClassSel);
    
    method_exchangeImplementations(firstMethod, secondMethod);
    
}

+ (void)kc_swizzlingClassMethod:(Class)firstClass firstClassSel:(SEL)firstClassSel secondClass:(Class)secondClass secondClassSel:(SEL)secondClassSel
{
    
    Method firstMethod = class_getClassMethod(firstClass, firstClassSel);
    
    Method secondMethod = class_getClassMethod(secondClass, secondClassSel);
    
    method_exchangeImplementations(firstMethod, secondMethod);
    
}

+ (void)kc_swizzlingInstanceMethod:(SEL)sel otherClass:(Class)otherClass otherClassSel:(SEL)otherClassSel
{
    [self kc_swizzlingInstanceMethod:self firstClassSel:sel secondClass:otherClass secondClassSel:otherClassSel];
}

+ (void)kc_swizzlingClassMethod:(SEL)sel otherClass:(Class)otherClass otherClassSel:(SEL)otherClassSel
{
    
    [self kc_swizzlingClassMethod:self firstClassSel:sel secondClass:otherClass secondClassSel:otherClassSel];
}


+ (void)kc_swizzlingInstanceMethod:(SEL)sel otherSel:(SEL)otherSel
{
    
    [self kc_swizzlingInstanceMethod:sel otherClass:self otherClassSel:otherSel];
}

+ (void)kc_swizzlingClassMethod:(SEL)sel otherSel:(SEL)otherSel
{
    
    [self kc_swizzlingClassMethod:sel otherClass:self otherClassSel:otherSel];
}
@end
