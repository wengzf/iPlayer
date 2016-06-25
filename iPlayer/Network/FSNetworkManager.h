//
//  NJNetWorkManager.h
//  FireShadow
//
//  Created by Mr nie on 15/4/18.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"

typedef void(^SuccessBlock)(long status, NSDictionary *dic);

typedef void(^SuccessWithErrorBlock)(long status, NSString *err, NSDictionary *dic);


#define FSNetworkManagerDefaultInstance  [FSNetworkManager instance]


// 8daluqp9xm2kw6zs1hta
@interface FSNetworkManager : NSObject
{
}


@property (nonatomic, strong)AFHTTPRequestOperationManager *networkingManager;

@property (nonatomic, strong) NSString *token;

+ (FSNetworkManager *)instance;




#pragma mark - 登录注册接口

// 注册
//POST /user/register
- (void)registerWithPhoneStr:(NSString *)phoneStr
                    password:(NSString *)password
                      nation:(NSString *)nation
              inviter_userid:(NSString *)inviter_userid
                    app_name:(NSString *)app_name
                 app_version:(NSString *)app_version
                    platform:(NSString *)platform
                successBlock:(SuccessBlock)sBlock;

// 登陆
//POST /user/login
- (void)loginWithPhoneStr:(NSString *)phoneStr
                 password:(NSString *)password
             successBlock:(SuccessBlock)sBlock;


// 更改密码
// user/changepasswd
- (void)changepasswdWithUserid:(NSString *)userid
                  old_password:(NSString *)old_password
                  new_password:(NSString *)new_password
                  successBlock:(SuccessBlock)sBlock;


// 退出登陆
//POST /user/logout
- (void)logoutWithPhoneStr:(NSString *)phoneStr
              successBlock:(SuccessBlock)sBlock;

// 用户详情
//POST /user/info
- (void)userInfoDetailWithUserID:(NSString *)userID
                    successBlock:(SuccessBlock)sBlock;




#pragma mark - 任务模块

// 获取任务列表
//POST /task/getlist
- (void)taskListWithUserID:(NSString *)userID
              successBlock:(SuccessBlock)sBlock;

// 签到
//POST /task/signin
- (void)signinWithUserID:(NSString *)userID
            successBlock:(SuccessBlock)sBlock;


// 分享
//POST /task/share
- (void)shareWithUserID:(NSString *)userID
               platform:(NSString *)platform                // 分享渠道 | 1微信 2微博
           successBlock:(SuccessBlock)sBlock;

// 我的金币记录列表
//POST /task/myrecords
- (void)myrecordsWithUserID:(NSString *)userID
       last_coins_record_id:(NSString *)last_coins_record_id
               successBlock:(SuccessBlock)sBlock;


#pragma mark - 刮刮卡模块
//POST /scratchcard/dopost
- (void)dopostWithUserID:(NSString *)userID
            successBlock:(SuccessBlock)sBlock;




#pragma mark - 活动模块
// 抽奖活动列表
//POST /activity/lotterylist
- (void)lotterylistWithUserID:(NSString *)userID
                   activityid:(NSString *)activityid
               successBlock:(SuccessBlock)sBlock;

// 抽奖详情
//POST /activity/lotteryinfo
- (void)lotteryinfoWithUserID:(NSString *)userID
                   activityid:(NSString *)activityid
                 successBlock:(SuccessBlock)sBlock;

// 参加抽奖
//POST /activity/dolottery
- (void)dolotteryWithUserID:(NSString *)userID
                   activityid:(NSString *)activityid
                 successBlock:(SuccessBlock)sBlock;

// 我的抽奖活动列表
//POST /activity/myrecords
- (void)myrecordsWithUserID:(NSString *)userID
         activity_record_id:(NSString *)activity_record_id
               successBlock:(SuccessBlock)sBlock;


#pragma mark - 兑换模块
//兑换列表
//POST /exchange/getlist
- (void)elistWithUserID:(NSString *)userID
       last_exchange_id:(NSString *)last_exchange_id
           successBlock:(SuccessBlock)sBlock;

//兑换
//POST /exchange/dopost
- (void)dopostWithUserID:(NSString *)userID
              exchangeid:(NSString *)exchangeid
        exchange_account:(NSString *)exchange_account
            successBlock:(SuccessBlock)sBlock;

//我的兑换活动列表
//POST /exchange/myrecords
- (void)myrecordsWithUserID:(NSString *)userID
         exchange_record_id:(NSString *)exchange_record_id
               successBlock:(SuccessBlock)sBlock;















@end


















