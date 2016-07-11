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


@interface FSNetworkManager : NSObject
{
}


@property (nonatomic, strong)AFHTTPRequestOperationManager *networkingManager;

@property (nonatomic, strong) NSString *token;

+ (FSNetworkManager *)instance;




#pragma mark - 登录注册接口

// 登陆
//POST /app/open
- (void)loginWithIDFAStr:(NSString *)idfaStr
            successBlock:(SuccessBlock)sBlock;













@end


















