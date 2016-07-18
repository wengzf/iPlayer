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


// 登陆
//POST /app/open
- (void)loginWithIDFAStr:(NSString *)idfaStr
             successBlock:(SuccessBlock)sBlock
{
    NSString *url = [FSNetworkManager packingURL:@"app/open"];
    NSDictionary *parameterDic  = @{@"idfa" : idfaStr,
                                    };
    
    parameterDic = [self encryptDictionaryWithParameters:parameterDic];
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        sBlock([dic[@"code"] integerValue],dic);
        
    }failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        sBlock(911,nil);
    }];
}


// 分享
//POST /app/share
- (void)shareWithIDFAStr:(NSString *)idfaStr
                  source:(NSString *)source
            successBlock:(SuccessBlock)sBlock
{
    NSString *url = [FSNetworkManager packingURL:@"app/share"];
    NSDictionary *parameterDic  = @{@"idfa" : idfaStr,
                                    @"source" : source
                                    };
    
    parameterDic = [self encryptDictionaryWithParameters:parameterDic];
    
    
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        sBlock([dic[@"code"] integerValue],dic);
        
    }failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        sBlock(911,nil);
    }];
}

// 通用路由接口
- (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSDictionary *responseDic, id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    NSString *url = [FSNetworkManager packingURL:URLString];
    NSDictionary *parameterDic = [self encryptDictionaryWithParameters:parameters];
    [networkingManager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
        success(dic, responseObject);
        
    }failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        failure(error);
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
