//
//  UIView+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/6.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "UIView+KCExtension.h"

#import <objc/message.h>

@implementation UIView (KCExtension)

#pragma mark -frame相关
- (void)setKc_x:(CGFloat)kc_x
{
    CGRect frame = self.frame;
    frame.origin.x = kc_x;
    self.frame = frame;
}

- (CGFloat)kc_x { return self.frame.origin.x; }

- (void)setKc_maxX:(CGFloat)kc_maxX { self.kc_x = kc_maxX - self.kc_width; }

- (CGFloat)kc_maxX { return CGRectGetMaxX(self.frame); }

- (void)setKc_maxY:(CGFloat)kc_maxY { self.kc_y = kc_maxY - self.kc_height; }

- (CGFloat)kc_maxY { return CGRectGetMaxY(self.frame); }

- (void)setKc_y:(CGFloat)kc_y
{
    CGRect frame = self.frame;
    frame.origin.y = kc_y;
    self.frame = frame;
}

- (CGFloat)kc_y { return self.frame.origin.y; }

- (void)setKc_centerX:(CGFloat)kc_centerX
{
    CGPoint center = self.center;
    center.x = kc_centerX;
    self.center = center;
}

- (CGFloat)kc_centerX { return self.center.x; }

- (void)setKc_centerY:(CGFloat)kc_centerY
{
    CGPoint center = self.center;
    center.y = kc_centerY;
    self.center = center;
}

- (CGFloat)kc_centerY { return self.center.y; }

- (void)setKc_width:(CGFloat)kc_width
{
    CGRect frame = self.frame;
    frame.size.width = kc_width;
    self.frame = frame;
}

- (CGFloat)kc_width { return self.frame.size.width; }

- (void)setKc_height:(CGFloat)kc_height
{
    CGRect frame = self.frame;
    frame.size.height = kc_height;
    self.frame = frame;
}

- (CGFloat)kc_height { return self.frame.size.height; }

- (void)setKc_size:(CGSize)kc_size
{
    CGRect frame = self.frame;
    frame.size = kc_size;
    self.frame = frame;
}

- (CGSize)kc_size { return self.frame.size; }

/**********************/

#pragma mark -transform相关
// helper to get pre transform frame
-(CGRect)kc_originalFrameAfterTransform {
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    CGRect originalFrame = self.frame;
    self.transform = currentTransform;
    return originalFrame;
}

// now get your corners
- (CGPoint)kc_topLeftAfterTransform {
    CGRect frame = [self kc_originalFrameAfterTransform];
    return [self kc_pointInViewAfterTransform:frame.origin];
}

- (CGPoint)kc_topRightAfterTransform {
    CGRect frame = [self kc_originalFrameAfterTransform];
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    return [self kc_pointInViewAfterTransform:point];
}

- (CGPoint)kc_bottomLeftAfterTransform {
    CGRect frame = [self kc_originalFrameAfterTransform];
    CGPoint point = frame.origin;
    point.y += frame.size.height;
    return [self kc_pointInViewAfterTransform:point];
}

- (CGPoint)kc_bottomRightAfterTransform {
    CGRect frame = [self kc_originalFrameAfterTransform];
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    point.y += frame.size.height;
    return [self kc_pointInViewAfterTransform:point];
}

// 辅助方法
- (CGPoint)kc_pointInViewAfterTransform:(CGPoint)thePoint {
    // get offset from center
    CGPoint offset = CGPointMake(thePoint.x - self.center.x, thePoint.y - self.center.y);
    // get transformed point
    CGPoint transformedPoint = CGPointApplyAffineTransform(offset, self.transform);
    // make relative to center
    return CGPointMake(transformedPoint.x + self.center.x, transformedPoint.y + self.center.y);
}


/**********************/

#pragma mark -截图相关
- (UIImage *)kc_screenshot { return [self kc_screenshotWithRect:self.bounds]; }

- (UIImage *)kc_screenshotWithRect:(CGRect)rect;
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        return nil;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    if( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else
    {
        [self.layer renderInContext:context];
    }
    
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**********************/

#pragma mark -分割线相关
+ (instancetype)kc_whiteSeparator
{
    UIView *view = [self new];
    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    return view;
}

+ (instancetype)kc_blackSeparator
{
    UIView *view = [self new];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    return view;
}

/**********************/

#pragma mark -xib相关
+ (instancetype)kc_viewFromXib { return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject]; }

+ (UINib *)kc_xib { return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil]; }


/**********************/
#pragma mark -显示红点
- (void)setKc_badgeValue:(NSString *)kc_badgeValue
{
    UILabel *badgeValueLabel = objc_getAssociatedObject(self, @"kc_badgeValueLabel");
    
    if (!badgeValueLabel) {
        badgeValueLabel = [[UILabel alloc] init];
        badgeValueLabel.font = [UIFont systemFontOfSize:10];
        badgeValueLabel.textColor = [UIColor whiteColor];
        badgeValueLabel.textAlignment = NSTextAlignmentCenter;
        badgeValueLabel.layer.backgroundColor = [UIColor redColor].CGColor;
        [self addSubview:badgeValueLabel];
        objc_setAssociatedObject(self, @"kc_badgeValueLabel", badgeValueLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    
    if (kc_badgeValue) {
        badgeValueLabel.hidden = NO;
        badgeValueLabel.text = kc_badgeValue;
        if (kc_badgeValue.length) {
            
            CGFloat h = 15;
            CGFloat minW = h;
            CGFloat w = [kc_badgeValue sizeWithAttributes:@{NSFontAttributeName : badgeValueLabel.font}].width + 8;
            
            w = w < minW ? minW : w;
            
            badgeValueLabel.frame = CGRectMake(self.frame.size.width - w, 0, w, h);
            
            badgeValueLabel.layer.cornerRadius = h * 0.5;
            
        }else {
            
            CGFloat wh = 8;
            badgeValueLabel.frame = CGRectMake(self.frame.size.width - wh, 0, wh, wh);
            
            badgeValueLabel.layer.cornerRadius = wh * 0.5;
        }
    }else {
        badgeValueLabel.hidden = YES;
    }
}

- (NSString *)kc_badgeValue
{
    UILabel *badgeValueLabel = objc_getAssociatedObject(self, @"kc_badgeValueLabel");
    return badgeValueLabel.text;
}

- (void)kc_setBadgeValue:(NSString *)badgeValue offset:(CGPoint)offset
{
    self.kc_badgeValue = badgeValue;
    
    UILabel *badgeValueLabel = objc_getAssociatedObject(self, @"kc_badgeValueLabel");
    
    CGRect temp = badgeValueLabel.frame;
    temp.origin.y += offset.y;
    temp.origin.x += offset.x;
    
    badgeValueLabel.frame = temp;
}


@end
