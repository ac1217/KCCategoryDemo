//
//  NSArray+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/6.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "NSArray+KCExtension.h"
#import "NSObject+KCExtension.h"

@implementation NSArray (KCExtension)

+ (void)load
{
    [self kc_swizzlingInstanceMethod:@selector(kc_objectAtIndex:) otherClass:NSClassFromString(@"__NSArrayI") otherClassSel:@selector(objectAtIndex:)];
    
    [self kc_swizzlingInstanceMethod:@selector(kc_arrayByAddingObject:) otherClass:NSClassFromString(@"__NSArrayI") otherClassSel:@selector(arrayByAddingObject:)];
}

- (NSArray *)kc_arrayByAddingObject:(id)anObject
{
    
#if DEBUG

#else
    if (!anObject) {
        
        NSLog(@"警告：(Array:%@)添加的对象为nil", self);
        
        return self;
    }
    
#endif
    return [self kc_arrayByAddingObject:anObject];
}

- (id)kc_objectAtIndex:(NSUInteger)objectIndex
{
    
#if DEBUG

#else
    if (objectIndex >= [self count]) {
        
        return nil;
    }
#endif
    
    return [self kc_objectAtIndex:objectIndex];
}

- (instancetype)kc_filter:(BOOL(^)(id obj))block
{
    
    NSMutableArray *arrayM = @[].mutableCopy;
    
    for (id obj in self) {
        
        if (block(obj)) {
            [arrayM addObject:obj];
        }
        
        
    }
    
    return arrayM;
    
}

- (instancetype)kc_map:(id(^)(id obj))block
{
    
    NSMutableArray *arrayM = @[].mutableCopy;
    
    for (id obj in self) {
        
        [arrayM addObject:block(obj)];
        
    }
    return arrayM;
    
}

#pragma mark -log
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"[\n"];
    // 遍历数组的所有元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,\n", obj];
    }];
    [str appendString:@"]"];
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    return str;
}

#pragma mark -元素顺序
// 数组元素倒序
- (instancetype)kc_reverseObjects
{
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = self.count - 1; i >= 0; i--) {
        id obj = self[i];
        [temp addObject:obj];
    }
    return temp;
}



@end
