//
//  KCMacro.h
//  categoryDemo
//
//  Created by zhangweiwei on 16/5/6.
//  Copyright © 2016年 Erica. All rights reserved.
//

#ifndef KCMacro_h
#define KCMacro_h

// 颜色相关宏
#define KC_RGBA_COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define KC_RGB_COLOR(r,g,b) KC_RGBA_COLOR(r,g,b,1)
#define KC_RANDOM_COLOR KC_RGB_COLOR(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))
#define KC_HEX_COLOR(hexValue) KC_RGB_COLOR(((hexValue & 0xFF0000) >> 16)/255.0,((hexValue & 0xFF00) >> 8)/255.0,(hexValue & 0xFF)/255.0)

// 单例宏
#define KC_NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]
#define KC_APPLICATION [UIApplication shareApplication]
#define KC_USER_DEFAULTS [NSUserDefaults standardUserDefaults]

// 通知相关宏
#define KC_REMOVE_NOTIFICATION [KC_NOTIFICATION_CENTER removeObserver:self];
#define KC_POST_NOTIFICATION(name,obj,info) [KC_NOTIFICATION_CENTER  postNotificationName:name object:obj userInfo:info];

#endif /* KCMacro_h */
