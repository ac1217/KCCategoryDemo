//
//  CALayer+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/17.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "CALayer+KCExtension.h"
#import <objc/message.h>

static NSString *const KCCoverLayerKey = @"kc_coverLayer";

@interface CALayer ()

@property (nonatomic, strong) CAShapeLayer *kc_coverLayer;

@end


@implementation CALayer (KCExtension)

- (CAShapeLayer *)kc_coverLayer
{
    CAShapeLayer *coverLayer = objc_getAssociatedObject(self, (__bridge const void *)(KCCoverLayerKey));
    
    if (!coverLayer) {
        
        coverLayer = [CAShapeLayer layer];
        coverLayer.fillRule = kCAFillRuleEvenOdd;
        [self addSublayer:coverLayer];
        objc_setAssociatedObject(self, (__bridge const void *)(KCCoverLayerKey), coverLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return coverLayer;
}


// 增加圆角遮盖

- (void)kc_setRoundedCoverWithBackgroundColor:(CGColorRef)color cornerRadius:(CGFloat)radius
{
    [self insertSublayer:self.kc_coverLayer above:self.sublayers.lastObject];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, -1, -1)];
    
    [path appendPath:[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius]];
    
    self.kc_coverLayer.path = path.CGPath;
    
    self.kc_coverLayer.fillColor = color;
}

@end
