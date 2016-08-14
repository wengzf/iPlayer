//
//  GlobalVar.h
//  WhiteSharkBusiness
//
//  Created by wzf_taker on 15/12/25.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kGlobalIDFA          @"kGlobalIDFA"
#define kGlobalToken          @"kGlobalToken"
#define kGlobalIsLogin        @"kGlobalIsLogin"
#define kGlobalDeviceToken    @"kGlobalDeviceToken"
#define kGlobalUserID         @"kGlobalUserID"
#define kGlobalZhifubaoAccount   @"kGlobalZhifubaoAccount"
#define kGlobalQQAccount         @"kGlobalQQAccount"
#define kGlobalHuafeiAccount     @"kGlobalHuafeiAccount"

#define kGlobalName             @"kGlobalName"
#define kGlobalMail             @"kGlobalMail"
#define kGlobalPhone            @"kGlobalPhone"
#define kGlobalCoins            @"kGlobalCoins"
#define kGlobalStatus           @"kGlobalStatus"
#define kGlobalPlatform         @"kGlobalPlatform"
#define kGlobalNation           @"kGlobalNation"
#define kGlobalApp_name         @"kGlobalApp_name"
#define kGlobalApp_version      @"kGlobalApp_version"



//*      userid: 用户ID | integer,
//*      name: 用户name | string,
//*      phone: 用户手机号 | string,
//*      email: 用户邮箱 | string,
//*      coins: 用户金币数 | integer,
//*      status: 用户状态 1 正常 2被锁定 | integer,
//*      nation: 用户国家码[两位] | string,
//*      app_name: app name | string,
//*      app_version: app version | string,
//*      platform: platform | string

#define Global [GlobalVar shareInstance]

#define CurVersion 10300

@interface GlobalVar : NSObject

+ (GlobalVar *)shareInstance;

@property (assign, nonatomic) BOOL isLogin;//等于@"1"表示处于登录状态


@property (nonatomic, strong) NSString *idfa; // IDFA

@property (nonatomic, strong) NSString *token; // 用于网络校验
@property (nonatomic, strong) NSString *deviceToken; // 用于推送和设备识别
@property (strong, nonatomic) NSString *userID;//用户id;

@property (strong, nonatomic) NSString *zhifubaoAccount; // 支付宝账号
@property (strong, nonatomic) NSString *qqAccount;      // QQ兑换账号
@property (strong, nonatomic) NSString *huafeiAccount;  // 话费兑换账号

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *mail;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *conis;

@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *nation;
@property (strong, nonatomic) NSString *app_name;
@property (strong, nonatomic) NSString *app_version;
@property (strong, nonatomic) NSString *platform;



- (void)refreshUserInfo;
- (void)saveUserInfo;
- (void)clearUserInfo;


@end
