//
//  NSMutableDictionary+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/6/21.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "NSMutableDictionary+KCExtension.h"
#import <objc/message.h>
#import "NSObject+KCExtension.h"

@implementation NSMutableDictionary (KCExtension)

+ (void)load
{
    
    [self kc_swizzlingInstanceMethod:@selector(kc_setObject:forKey:) otherClass:NSClassFromString(@"__NSDictionaryM") otherClassSel:@selector(setObject:forKey:)];
    
    [self kc_swizzlingInstanceMethod:@selector(kc_removeObjectForKey:) otherClass:NSClassFromString(@"__NSDictionaryM") otherClassSel:@selector(removeObjectForKey:)];
}


- (void)kc_removeObjectForKey:(id)aKey {
    
#if DEBUG

#else

    if (!aKey) {

        NSLog(@"警告：(Dictionary:%@)key = nil",self);

        return;
    }
#endif
    
    [self kc_removeObjectForKey:aKey];
}

- (void)kc_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
  
#if DEBUG
    
#else
    
    if (!aKey) {
        
        NSLog(@"警告：(Dictionary:%@)key = nil",self);
        
        return;
    }
    
    if (!anObject) {
        
        NSLog(@"警告：(Dictionary:%@)添加的对象为nil",self);
        
        return;
    }
#endif
    
    
    [self kc_setObject:anObject forKey:aKey];
}

@end
