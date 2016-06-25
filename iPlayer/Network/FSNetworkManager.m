//
//  NJNetWorkManager.m
//  FireShadow
//
//  Created by Mr nie on 15/4/18.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//
#import "FSNetworkManager.h"
#import "CocoaSecurity.h"
#import "EncryptUtil.h"

@implementation FSNetworkManager

@synthesize networkingManager;

+ (FSNetworkManager *)instance
{
    static FSNetworkManager * instance;
    @synchronized(self){
        if (!instance) {
            instance = [[FSNetworkManager alloc] init];
            
            instance.networkingManager = [AFHTTPRequestOperationManager manager];

//            instance.networkingManager.responseSerializer = [AFJSONResponseSerializer serializer];
            instance.networkingManager.responseSerializer = [AFHTTPResponseSerializer serializer];

        
            instance.networkingManager.requestSerializer.timeoutInterval = 10;
        
        }
    }
    return instance;
}


+ (NSString *)packingURL:(NSString *) url
{

    NSString *baseURL = @"http://www.shoujizhuan.com.cn/";
    
    return [baseURL stringByAppendingString:url];
}



// 注册
//POST /user/register
- (void)registerWithPhoneStr:(NSString *)phoneStr
                    password:(NSString *)password
                      nation:(NSString *)nation
              inviter_userid:(NSString *)inviter_userid
                    app_name:(NSString *)app_name
                 app_version:(NSString *)app_version
                    platform:(NSString *)platform
                successBlock:(SuccessBlock)sBlock
{
    NSString *url = [FSNetworkManager packingURL:@"user/register"];
    NSDictionary *parameterDic  = @{@"phone" : phoneStr,
                                    @"password" : password,
                                    @"nation" : nation,
                                    @"inviter_userid" : inviter_userid,
                                    @"app_name" : app_name,
                                    @"app_version" : app_version,
                                    @"platform" : platform
                                    };
    
    parameterDic = [self encryptDictionaryWithParameters:parameterDic];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
}

// 登陆
//POST /user/login
- (void)loginWithPhoneStr:(NSString *)phoneStr
                 password:(NSString *)password
             successBlock:(SuccessBlock)sBlock
{
    NSString *url = [FSNetworkManager packingURL:@"user/login"];
    NSDictionary *parameterDic  = @{@"phone" : phoneStr,
                                    @"password" : password
                                    };
    
    parameterDic = [self encryptDictionaryWithParameters:parameterDic];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        
        NSDictionary *dic = responseObject;
        
            
        sBlock([dic[@"code"] integerValue],dic);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        sBlock(911,nil);
        
    }];
}


// 更改密码
// user/changepasswd
- (void)changepasswdWithUserid:(NSString *)userid
                  old_password:(NSString *)old_password
                  new_password:(NSString *)new_password
              successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"user/changepasswd";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" :userid,
                                    @"old_password":old_password,
                                    @"new_password":new_password
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


// 退出登陆
//POST /user/logout
- (void)logoutWithPhoneStr:(NSString *)phoneStr
              successBlock:(SuccessBlock)sBlock
{
    NSString *url = [FSNetworkManager packingURL:@"user/logout"];
    NSDictionary *parameterDic  = @{@"phone" :phoneStr
                                    };
    
    parameterDic = [self encryptDictionaryWithParameters:parameterDic];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
            sBlock(911,nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

// 用户详情
//POST /user/info
- (void)userInfoDetailWithUserID:(NSString *)userID
              successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"user/info";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
 
    }];
}

#pragma mark - 任务模块
// 获取任务列表
//POST /task/getlist
- (void)taskListWithUserID:(NSString *)userID
              successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"task/getlist";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

// 签到
//POST /task/signin
- (void)signinWithUserID:(NSString *)userID
            successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"task/signin";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


// 分享
//POST /task/share
- (void)shareWithUserID:(NSString *)userID
               platform:(NSString *)platform                // 分享渠道 | 1微信 2微博
           successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"task/share";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID,
                                    @"platform" : platform
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


// 我的金币记录列表
//POST /task/myrecords
- (void)myrecordsWithUserID:(NSString *)userID
       last_coins_record_id:(NSString *)last_coins_record_id
               successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"task/myrecords";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID,
                                    @"last_id" : last_coins_record_id
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 刮刮卡模块
//POST /scratchcard/dopost
- (void)dopostWithUserID:(NSString *)userID
            successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"scratchcard/dopost";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;

        sBlock([dic[@"code"] integerValue],dic);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 活动模块
// 抽奖活动列表
//POST /activity/lotterylist
- (void)lotterylistWithUserID:(NSString *)userID
                   activityid:(NSString *)activityid
                 successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"activity/lotterylist";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID,
                                    @"activityid" : activityid
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

// 抽奖详情
//POST /activity/lotteryinfo
- (void)lotteryinfoWithUserID:(NSString *)userID
                   activityid:(NSString *)activityid
                 successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"activity/lotteryinfo";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID,
                                    @"activityid" : activityid
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

// 参加抽奖
//POST /activity/dolottery
- (void)dolotteryWithUserID:(NSString *)userID
                 activityid:(NSString *)activityid
               successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"activity/dolottery";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID,
                                    @"activityid" : activityid
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

// 我的抽奖活动列表
//POST /activity/myrecords
- (void)myrecordsWithUserID:(NSString *)userID
         activity_record_id:(NSString *)activity_record_id
               successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"activity/myrecords";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID,
                                    @"activity_record_id" : activity_record_id
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 兑换模块
//兑换列表
//POST /exchange/getlist
- (void)elistWithUserID:(NSString *)userID
       last_exchange_id:(NSString *)last_exchange_id
           successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"exchange/getlist";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID,
                                    @"last_id" : last_exchange_id
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

//兑换
//POST /exchange/dopost
- (void)dopostWithUserID:(NSString *)userID
              exchangeid:(NSString *)exchangeid
        exchange_account:(NSString *)exchange_account
            successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"exchange/dopost";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID,
                                    @"exchangeid" : exchangeid,
                                    @"exchange_account": exchange_account
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        sBlock(0,responseObject);
    
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        sBlock(911,nil);
    }];
}

//我的兑换活动列表
//POST /exchange/myrecords
- (void)myrecordsWithUserID:(NSString *)userID
         exchange_record_id:(NSString *)exchange_record_id
               successBlock:(SuccessBlock)sBlock
{
    NSString *path = @"exchange/myrecords";
    NSString *url = [FSNetworkManager packingURL:path];
    NSDictionary *parameterDic  = @{@"userid" : userID,
                                    @"last_id" : exchange_record_id
                                    };
    
    parameterDic = [self packHmacAndThreeDesWithDic:parameterDic withURL:path];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSError *err;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] integerValue] == 1000) {
            // 成功
            sBlock(1000,dic[@"data"]);
        }else{
            // 显示错误信息
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 加密和token验证

- (NSDictionary *)packHmacAndThreeDesWithDic:(NSDictionary *)params withURL:(NSString *)url
{
    //    POST
    //    /sendmessage
    //    auth_key=token&auth_timestamp=1448522850&auth_version=1.0.0&msg=hello 2222&to=2
    
    NSString *tokenStr = @"";
    if (Global.token == nil || [Global.token isEqualToString:@""]) {
        tokenStr = @"";
    }
    else
    {
        tokenStr = Global.token;
    }
    
    // 设置http请求头
    NSString *author = [NSString stringWithFormat:@"Bearer %@", tokenStr];
    [networkingManager.requestSerializer setValue:author forHTTPHeaderField:@"Authorization"];
    
    
    NSDate *date = [NSDate date];
    NSTimeInterval timeinterval = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%.0lf",timeinterval];
    
    
    //    NSMutableString *tmpStr = [NSMutableString stringWithFormat:@"POST\n/%@\n",url];
    NSMutableString *tmpStr = [NSMutableString stringWithFormat:@"POST&/%@&",url];
    
    NSString *devicetoken = Global.deviceToken;
    
    if (Global.deviceToken == nil || [Global.deviceToken isEqualToString:@""]) {
        devicetoken = @"dddddd";
    }
    
    NSMutableDictionary * newDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    
    [newDic setObject:tokenStr forKey:@"auth_key"];
    [newDic setObject:[NSString stringWithFormat:@"%.0lf",timeinterval] forKey:@"auth_timestamp"];
    [newDic setObject:@"1.1.1" forKey:@"auth_version"];
    [newDic setObject:@"ios" forKey:@"client"];
    [newDic setObject:devicetoken forKey:@"uuid"];
    
    
    NSArray * array = newDic.allKeys;
    NSArray * newArray = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableString * Str1 = [[NSMutableString alloc] init];
    
    for (int i = 0 ; i < newArray.count; i++) {
        [Str1 appendString:[NSString stringWithFormat:@"&%@=%@", newArray[i], newDic[newArray[i]]]];
        
    }
    [Str1 deleteCharactersInRange:NSMakeRange(0, 1)];
    [tmpStr appendString:Str1];
    
    CocoaSecurityResult *signature = [CocoaSecurity hmacSha256:tmpStr hmacKey:tokenStr];
    // 字典
    NSMutableDictionary *dic;
    if (params == nil) {
        dic = [NSMutableDictionary new];
    }else{
        dic = [params mutableCopy];
    }
    NSString * newSign = [signature.hex lowercaseString];
    
    [dic addEntriesFromDictionary:@{
                                    @"auth_key": tokenStr,
                                    @"auth_timestamp": timeStr,
                                    @"auth_version": @"1.1.1",
                                    @"auth_signature": newSign,
                                    @"client" : @"ios",
                                    @"uuid" : devicetoken
                                    }];
    
    return [self encryptDictionaryWithParameters:dic];
}
- (NSDictionary *)encryptDictionaryWithParameters:(NSDictionary *)params
{
    NSError *error = nil;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"[net]GotParams: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSString *encValues = [EncryptUtil encryptWithText:jsonString];
    
    return @{@"i":encValues};
}


@end
