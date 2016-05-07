//
//  UIDevice+KCExtension.h
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/7.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const UIDeviceModelIPhone1G;
extern NSString *const UIDeviceModelIPhone3G;
extern NSString *const UIDeviceModelIPhone3GS;
extern NSString *const UIDeviceModelIPhone4;
extern NSString *const UIDeviceModelVerizonIPhone4;
extern NSString *const UIDeviceModelIPhone4S;
extern NSString *const UIDeviceModelIPhone5;
extern NSString *const UIDeviceModelIPhone5s;
extern NSString *const UIDeviceModelIPhone6;
extern NSString *const UIDeviceModelIPhone6Plus;
extern NSString *const UIDeviceModelIPhone6s;
extern NSString *const UIDeviceModelIPhone6sPlus;
extern NSString *const UIDeviceModelSimulator;
extern NSString *const UIDeviceModelIPodTouch1G;
extern NSString *const UIDeviceModelIPodTouch2G;
extern NSString *const UIDeviceModelIPodTouch3G;
extern NSString *const UIDeviceModelIPodTouch4G;
extern NSString *const UIDeviceModelIPad;
extern NSString *const UIDeviceModelIPad2WIFI;
extern NSString *const UIDeviceModelIPad2CDMA;
extern NSString *const UIDeviceModelIPad2GSM;
extern NSString *const UIDeviceModelIPad4WIFI;

@interface UIDevice (KCExtension)

+ (NSString*)kc_deviceModel;

@end
