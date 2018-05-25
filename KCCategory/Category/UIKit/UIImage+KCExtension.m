//
//  UIImage+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/6.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "UIImage+KCExtension.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
@import Accelerate;

@implementation UIImage (KCExtension)
#pragma mark -图片方向相关
- (UIImage *)kc_fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}

#pragma mark -颜色相关
- (UIImage *)kc_renderImageWithColor:(UIColor *)color level:(CGFloat)level
{
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawInRect:imageRect];
    
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetAlpha(ctx, level);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, imageRect);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef
                                         scale:self.scale
                                   orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


+ (UIImage *)kc_colorImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context  = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)kc_colorImageWithColor:(UIColor *)color
{
    return [self kc_colorImageWithColor:color size:CGSizeMake(1, 1)];
}

#pragma mark -图片裁剪缩放相关
- (UIImage *)kc_roundedImageWithCornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)kc_roundedImageWithCornerRadius:(CGFloat)cornerRadius completion:(void(^)(UIImage *image))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *image = [self kc_roundedImageWithCornerRadius:cornerRadius];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            !completion ? : completion(image);
            
        });
        
    });
}

- (UIImage *)kc_circleImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (NSArray *)kc_imagesWithData:(NSData *)data
{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //2. 将gif分解为一帧帧
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray * images = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < count; i ++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        //3. 将单帧数据转为UIImage
        UIImage * image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [images addObject:image];
        CGImageRelease(imageRef);
    }
    CFRelease(source);
    
    return images;
}

- (void)kc_circleImageWithCompletion:(void(^)(UIImage *image))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *circleImage = [self kc_circleImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            !completion ? : completion(circleImage);
            
        });
        
    });
}

- (UIImage *)kc_imageWithScale:(CGFloat)scale
{
    CGFloat w = self.size.width * scale;
    CGFloat h = self.size.height * scale;
    return [self kc_imageWithSize:CGSizeMake(w, h)];
}


- (UIImage *)kc_imageWithHeight:(CGFloat)height
{
    
    CGFloat w = height * self.size.width / self.size.height;
    return [self kc_imageWithSize:CGSizeMake(w, height)];
}

- (UIImage *)kc_imageWithWidth:(CGFloat)width
{
    CGFloat h = width * self.size.height / self.size.width;
    return [self kc_imageWithSize:CGSizeMake(width, h)];
}

- (UIImage *)kc_imageWithSize:(CGSize)size
{
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)kc_imageWithRect:(CGRect)rect
{
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [self CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
    
}

- (UIImage *)kc_drawText:(NSString *)text atPoint:(CGPoint)point attributes:(NSDictionary *)attributes
{
    
    CGSize size = [text sizeWithAttributes:attributes];
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    CGFloat x = point.x - w * 0.5;
    CGFloat y = point.y - h * 0.5;
    
    return [self kc_drawText:text inRect:CGRectMake(x, y, w, h) attributes:attributes];
}

- (UIImage *)kc_drawText:(NSString *)text inRect:(CGRect)rect attributes:(NSDictionary *)attributes
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    [text drawInRect:rect withAttributes:attributes];
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIImage *)kc_drawImage:(UIImage *)image inRect:(CGRect)rect
{
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [image drawInRect:rect];
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIImage *)kc_resizedImage
{
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}

/**
 *  根据图片返回一张高斯模糊的图片
 *
 *  @param blur 模糊系数 (0 ~ 1)
 *
 *  @return 新的图片
 */


- (UIImage *)kc_blurImageWithRatio:(CGFloat)ratio
{
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    
    CIImage *filtered = [[[inputImage imageByClampingToExtent] imageByApplyingFilter:@"CIGaussianBlur" withInputParameters:@{kCIInputRadiusKey:@(ratio*100)}] imageByCroppingToRect:inputImage.extent];
    
    CIContext *ciCtx = [CIContext contextWithOptions:nil];
    
    CGImageRef renderImage = [ciCtx createCGImage:filtered fromRect:inputImage.extent];
    
    UIImage *img = [UIImage imageWithCGImage:renderImage];
    
    CGImageRelease(renderImage);
//    [ciCtx clearCaches];
    
    return img;
}

- (void)kc_blurImageWithRatio:(CGFloat)ratio competion:(void(^)(UIImage *img))competion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *img = [self kc_blurImageWithRatio:ratio];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            !competion ? : competion(img);
        });
        
    });
    
}
- (UIImage *)kc_imageWithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}




#pragma mark -视频相关
+ (UIImage *)kc_firstFrameImageWithVideoURL:(NSURL *)url
{
    return [self kc_imageWithVideoURL:url atTime:0];
}

+ (UIImage *)kc_imageWithVideoURL:(NSURL *)url atTime:(NSTimeInterval)time
{
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    generator.appliesPreferredTrackTransform = YES;
    
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    
    CMTime actualTime;
    
    CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(time * asset.duration.timescale, asset.duration.timescale) actualTime:&actualTime error:nil];
    
    return [UIImage imageWithCGImage:cgImage];
}


+ (void)kc_imagesWithVideoURL:(NSURL *)url
                       atTime:(NSTimeInterval)time
                     duration:(NSTimeInterval)duration
                          fps:(int)fps
                      process:(UIImage *(^)(UIImage *image))process
                   completion:(void(^)(NSArray <UIImage *>*images))completion
{
    
    if (duration < 0 || time < 0 || fps <= 0) {
        return;
    }
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    generator.appliesPreferredTrackTransform = YES;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    fps = MIN(fps, 30);
    
    NSInteger frameCount = duration * fps;
    
    NSInteger startTime = time * fps;
    
    NSMutableArray *times = @[].mutableCopy;
    for (NSInteger i = startTime; i < (startTime + frameCount); i++) {
        
        [times addObject:[NSValue valueWithCMTime:CMTimeMake(i, fps)]];
        
    }
    
    NSMutableArray *images = @[].mutableCopy;
    
    [generator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        
        UIImage *uiImage = [UIImage imageWithCGImage:image];
        
        if (process) {
            uiImage = process(uiImage);
        }
        
        if (uiImage) {
            
            [images addObject:uiImage];
        }
        
        if (requestedTime.value >= startTime + frameCount - 1) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                !completion ? : completion(images);
            });
            
        }
        
    }];
    
}


+ (void)kc_createGIFWithVideoURL:(NSURL *)url
                          toPath:(NSString *)path
                          atTime:(NSTimeInterval)time
                        duration:(NSTimeInterval)duration
                        videoFps:(int)videoFps
                    gifDelayTime:(NSTimeInterval)gifDelayTime
                      completion:(void(^)(NSString *path, BOOL success))completion
{
    [self kc_imagesWithVideoURL:url atTime:time duration:duration fps:videoFps process:nil completion:^(NSArray<UIImage *> *images) {
        
        [self kc_createGIFWithImages:images toPath:path delayTime:gifDelayTime completion:completion];
        
    }];
}


+ (void)kc_createGIFWithImages:(NSArray *)images
                        toPath:(NSString *)path
                     delayTime:(NSTimeInterval)delayTime
                    completion:(void(^)(NSString *path, BOOL success))completion
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //配置gif属性
        CGImageDestinationRef destion;
        CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false);
        destion = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, NULL);
        NSDictionary *frameDic = [NSDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:delayTime],(NSString*)kCGImagePropertyGIFDelayTime, nil] forKey:(NSString*)kCGImagePropertyGIFDictionary];
        
        NSMutableDictionary *gifParmdict = [NSMutableDictionary dictionaryWithCapacity:2];
        [gifParmdict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
        [gifParmdict setObject:(NSString*)kCGImagePropertyColorModelRGB forKey:(NSString*)kCGImagePropertyColorModel];
        [gifParmdict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
        [gifParmdict setObject:[NSNumber numberWithInt:0] forKey:(NSString*)kCGImagePropertyGIFLoopCount];
        NSDictionary *gifProperty = [NSDictionary dictionaryWithObject:gifParmdict forKey:(NSString*)kCGImagePropertyGIFDictionary];
        
        for (UIImage *dimage in images) {
            CGImageDestinationAddImage(destion, dimage.CGImage, (__bridge CFDictionaryRef)frameDic);
        }
        
        CGImageDestinationSetProperties(destion,(__bridge CFDictionaryRef)gifProperty);
        BOOL rs = CGImageDestinationFinalize(destion);
        CFRelease(destion);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            !completion ? : completion(path, rs);
            
        });
        
    });
    
}

@end

