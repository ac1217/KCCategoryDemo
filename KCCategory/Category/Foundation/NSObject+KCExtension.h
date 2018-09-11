//
//  NSObject+KCExtension.h
//  categoryDemo
//
//  Created by Erica on 2017/12/6.
//  Copyright © 2017年 Erica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KCExtension)

+ (void)kc_swizzlingInstanceMethod:(Class)firstClass firstClassSel:(SEL)firstClassSel secondClass:(Class)secondClass secondClassSel:(SEL)secondClassSel;

+ (void)kc_swizzlingClassMethod:(Class)firstClass firstClassSel:(SEL)firstClassSel secondClass:(Class)secondClass secondClassSel:(SEL)secondClassSel;

+ (void)kc_swizzlingInstanceMethod:(SEL)sel otherClass:(Class)otherClass otherClassSel:(SEL)otherClassSel;

+ (void)kc_swizzlingClassMethod:(SEL)sel otherClass:(Class)otherClass otherClassSel:(SEL)otherClassSel;

+ (void)kc_swizzlingInstanceMethod:(SEL)sel otherSel:(SEL)otherSel;
+ (void)kc_swizzlingClassMethod:(SEL)sel otherSel:(SEL)otherSel;

@end
