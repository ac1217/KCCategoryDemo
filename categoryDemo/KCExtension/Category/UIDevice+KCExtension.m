//
//  UIDevice+KCExtension.m
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/7.
//  Copyright © 2016年 Erica. All rights reserved.
//

#import "UIDevice+KCExtension.h"
#import <sys/utsname.h>

static NSString *const UIDeviceModelIPhone1G = @"iPhone 1G";
static NSString *const UIDeviceModelIPhone3G = @"iPhone 3G";
static NSString *const UIDeviceModelIPhone3GS = @"iPhone 3GS";
static NSString *const UIDeviceModelIPhone4 = @"iPhone 4";
static NSString *const UIDeviceModelVerizonIPhone4 = @"Verizon iPhone 4";
static NSString *const UIDeviceModelIPhone4S = @"iPhone 4S";
static NSString *const UIDeviceModelIPhone5 = @"iPhone 5";
static NSString *const UIDeviceModelIPhone5s = @"iPhone 5s";
static NSString *const UIDeviceModelIPhone6 = @"iPhone 6";
static NSString *const UIDeviceModelIPhone6Plus = @"iPhone 6 Plus";
static NSString *const UIDeviceModelIPhone6s = @"iPhone 6s";
static NSString *const UIDeviceModelIPhone6sPlus = @"iPhone 6s Plus";
static NSString *const UIDeviceModelSimulator = @"Simulator";
static NSString *const UIDeviceModelIPodTouch1G = @"iPod Touch 1G";
static NSString *const UIDeviceModelIPodTouch2G = @"iPod Touch 2G";
static NSString *const UIDeviceModelIPodTouch3G = @"iPod Touch 3G";
static NSString *const UIDeviceModelIPodTouch4G = @"iPod Touch 4G";
static NSString *const UIDeviceModelIPad = @"iPad";
static NSString *const UIDeviceModelIPad2WIFI = @"iPad 2 WIFI";
static NSString *const UIDeviceModelIPad2CDMA = @"iPad 2 CDMA";
static NSString *const UIDeviceModelIPad2GSM = @"iPad 2 GSM";
static NSString *const UIDeviceModelIPad4WIFI = @"iPad 4 WIFI";

@implementation UIDevice (KCExtension)

+ (NSString*)kc_deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return UIDeviceModelIPhone1G;
    if ([deviceString isEqualToString:@"iPhone1,2"])    return UIDeviceModelIPhone3G;
    if ([deviceString isEqualToString:@"iPhone2,1"])    return UIDeviceModelIPhone3GS;
    if ([deviceString isEqualToString:@"iPhone3,1"])    return UIDeviceModelIPhone4;
    if ([deviceString isEqualToString:@"iPhone3,2"])    return UIDeviceModelVerizonIPhone4;
    if ([deviceString isEqualToString:@"iPhone4,1"])    return UIDeviceModelIPhone4S;
    if ([deviceString isEqualToString:@"iPhone5,2"])    return UIDeviceModelIPhone5;
    if ([deviceString isEqualToString:@"iPhone6,2"])    return UIDeviceModelIPhone5s;
    if ([deviceString isEqualToString:@"iPhone7,2"])    return UIDeviceModelIPhone6;
    if ([deviceString isEqualToString:@"iPhone7,1"])    return UIDeviceModelIPhone6Plus;
    if ([deviceString isEqualToString:@"iPhone8,2"])    return UIDeviceModelIPhone6sPlus;
    if ([deviceString isEqualToString:@"iPhone8,1"])    return UIDeviceModelIPhone6s;
    
    if ([deviceString isEqualToString:@"i386"])         return UIDeviceModelSimulator;
    if ([deviceString isEqualToString:@"x86_64"])       return UIDeviceModelSimulator;
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return UIDeviceModelIPodTouch1G;
    if ([deviceString isEqualToString:@"iPod2,1"])      return UIDeviceModelIPodTouch2G;
    if ([deviceString isEqualToString:@"iPod3,1"])      return UIDeviceModelIPodTouch3G;
    if ([deviceString isEqualToString:@"iPod4,1"])      return UIDeviceModelIPodTouch4G;
    if ([deviceString isEqualToString:@"iPad1,1"])      return UIDeviceModelIPad;
    if ([deviceString isEqualToString:@"iPad2,1"])      return UIDeviceModelIPad2WIFI;
    if ([deviceString isEqualToString:@"iPad2,2"])      return UIDeviceModelIPad2GSM;
    if ([deviceString isEqualToString:@"iPad2,3"])      return UIDeviceModelIPad2CDMA;
    if ([deviceString isEqualToString:@"iPad3,4"])      return UIDeviceModelIPad4WIFI;
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;

}
@end
