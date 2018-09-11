//
//  NSMutableArray+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/6/21.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "NSMutableArray+KCExtension.h"
#import "NSObject+KCExtension.h"

@implementation NSMutableArray (KCExtension)

+ (void)load
{
    [self kc_swizzlingInstanceMethod:@selector(kc_addObject:) otherClass:NSClassFromString(@"__NSArrayM") otherClassSel:@selector(addObject:)];
    
    [self kc_swizzlingInstanceMethod:@selector(kc_insertObject:atIndex:) otherClass:NSClassFromString(@"__NSArrayM") otherClassSel:@selector(insertObject:atIndex:)];
    
    [self kc_swizzlingInstanceMethod:@selector(kc_replaceObjectAtIndex:withObject:) otherClass:NSClassFromString(@"__NSArrayM") otherClassSel:@selector(replaceObjectAtIndex:withObject:)];
    
    
    [self kc_swizzlingInstanceMethod:@selector(kc_removeObjectAtIndex:) otherClass:NSClassFromString(@"__NSArrayM") otherClassSel:@selector(removeObjectAtIndex:)];
}

- (void)kc_removeObjectAtIndex:(NSUInteger)atIndex
{
    
#if DEBUG
    
#else
    
    if (atIndex >= self.count) {
        
        NSLog(@"警告：(Array:%@)数组越界index=%zd,count=%zd", self, atIndex, self.count);
        
        return;
    }
#endif
    
    [self kc_removeObjectAtIndex:atIndex];
    
}


- (void)kc_addObject:(id)anObject
{
    
#if DEBUG
    
#else
    if (!anObject) {
        
        NSLog(@"警告：(Array:%@)添加的对象为nil",self);
        
        return;
    }
#endif
    
    [self kc_addObject:anObject];
    
}

- (void)kc_replaceObjectAtIndex:(NSUInteger)atIndex withObject:(id)anObject
{
    
#if DEBUG
    
#else
    if (!anObject) {
        
        NSLog(@"警告：(Array:%@)添加的对象为nil", self);
        
        return;
    }
    
    if (atIndex >= self.count) {
        
        NSLog(@"警告：(Array:%@)数组越界index=%zd,count=%zd", self, atIndex, self.count);
        
        return;
    }
#endif
    
    [self kc_replaceObjectAtIndex:atIndex withObject:anObject];
}

- (void)kc_insertObject:(id)anObject atIndex:(NSUInteger)atIndex
{
  
#if DEBUG
    
#else
    if (!anObject) {
        
        NSLog(@"警告：(Array:%@)添加的对象为nil", self);
        
        return;
    }
    
    if (atIndex > self.count) {
        
        NSLog(@"警告：(Array:%@)数组越界index=%zd,count=%zd", self, atIndex, self.count);
        
        return;
    }
#endif
    
    [self kc_insertObject:anObject atIndex:atIndex];
}

@end
