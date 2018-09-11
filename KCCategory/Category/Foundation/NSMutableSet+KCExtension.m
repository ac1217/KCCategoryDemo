//
//  NSMutableSet+KCExtension.m
//  categoryDemo
//
//  Created by Erica on 2018/5/25.
//  Copyright © 2018年 Erica. All rights reserved.
//

#import "NSMutableSet+KCExtension.h"
#import "NSObject+KCExtension.h"

@implementation NSMutableSet (KCExtension)

+ (void)load
{
    [self kc_swizzlingInstanceMethod:@selector(kc_addObject:) otherClass:NSClassFromString(@"__NSSetM") otherClassSel:@selector(addObject:)];
    
}


- (void)kc_addObject:(id)anObject
{
    
#if DEBUG
    
#else
    if (!anObject) {
        
        NSLog(@"警告：(Set:%@)添加的对象为nil",self);
        
        return;
    }
#endif
    
    [self kc_addObject:anObject];
    
}


@end
