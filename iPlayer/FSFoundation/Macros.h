//
//  Macros.h
//  FireShadow
//
//  Created by 翁志方 on 15/9/23.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#ifndef FireShadow_Macros_h
#define FireShadow_Macros_h




#define currentVersion @"1.0.0"                 // 当前版本号

#define kDeviceToken  @"deviceToken"            // 设备token

#define kUserToken @"kUserToken"                // 用户token
#define kUserISLogin @"kUserISLogin"            // 用户登录状态
#define kUserID @"kUserID"                      // 用户ID


#define kNZDeviceToken  @"kNZDeviceToken"       // 存储设备的token   设备token在更新和用户登录时提交后端

#define NetWorkUnavailablePromptStr  @"网络中断，请检查网络"     // 网络连接中断提示信息

#define encryptDesKey   @"8daluqp9xm2kw6zs1hta"             // 数据加密用key





/*
 *  工具
 */

#define checkNull(id)   (id != nil && ![id isEqual:[NSNull null]])
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;       // 弱引用


#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0 ? YES : NO) //判断是否为ios7.0以前

#define IsIphone4 ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)              //判断是否是ipone4

/*
 *  通知
 */

#define  HomeVCRefreshNotification @"kHomeVCRefreshNotification"    // 登录通知




#endif
