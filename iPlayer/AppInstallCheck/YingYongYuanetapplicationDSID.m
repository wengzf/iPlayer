//
//  GetapplicationDSID.m
//  微加钥匙
//
//  Created by 云冯 on 16/2/22.
//  Copyright © 2016年 冯云. All rights reserved.
//

#include <objc/runtime.h>

#import "YingYongYuanetapplicationDSID.h"
#import "LMAppController.h"

@implementation YingYongYuanetapplicationDSID
-(int) getAppState:(NSString *) package
{
    
    NSArray * apps;
    if ([YingYongYuanetapplicationDSID getIOSVersion]>=8.0) {
        apps = [LMAppController sharedInstance].inApplications;
        if(package.length!=0){
            for(LMApp* app in apps){
                if ([app.bunidfier isEqualToString:package ]) {
                    return 1;
                }
            }
        }
    }else
    {
        SEL my_sel = NSSelectorFromString([NSString stringWithFormat:@"%@%@%@",@"de",@"faultWor",@"kspace"]);
        NSString*str1 = [self deJson:@"T9npsF4wr1NwqcmBlhifcls3wHbw6uBy5xmsjue9aWNhdGlvbldvcmtzcGFjZQ,,"];
        //LSApplicationWorkspace
        //"LSApplicationWorkspace"
        Class LSApplicationWorkspace_class = objc_getClass([str1 UTF8String]);
//        Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
        NSObject* workspace = [LSApplicationWorkspace_class performSelector:my_sel];
        SEL my_sel2 = NSSelectorFromString([NSString stringWithFormat:@"%@%@%@",@"all",@"Appli",@"cations"]);
        
        NSArray * resArray=[workspace performSelector:my_sel2];
        
        for (LSApplicationWorkspace_class in resArray) {
            NSString * appName=[LSApplicationWorkspace_class performSelector:@selector(description)];
            if ([appName rangeOfString:package].location!=NSNotFound)
            {
                return 1;
            }
        }
    }
    return 0;
}
+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
+(YingYongYuanetapplicationDSID *)sharedInstance{
    static dispatch_once_t onceToken;
    static YingYongYuanetapplicationDSID * appId;
    dispatch_once(&onceToken, ^{
        appId=[[YingYongYuanetapplicationDSID alloc]init];
    });
    return appId;
}


-(NSString *) deJson:(NSString *) string{
    NSString * base64 = @"";
    for (int i = 0; i<[string length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        if((i>=1 && i<=4) || (i>=6 && i<=9)||  (i>=11 && i<=14) ||  (i>=16 && i<=19) ||  (i>=21 && i<=24) ||  (i>=26 && i<=29)  ||  (i>=31 && i<=34)  ||  (i>=36 && i<=39)){
            continue;
        }
        base64 =  [base64 stringByAppendingString:s];
    }
    //YingYongYuanjStringUtil.h
    base64 = [self replace:base64 reg:@"-" target:@"+"];
    base64 = [self replace:base64 reg:@"_" target:@"/"];
    base64 = [self replace:base64 reg:@"," target:@"="];
    
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    return decodedString;
}

-(NSString *) replace:(NSString *) str reg:(NSString *) reg target:(NSString *) targetStr{
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:reg withString:targetStr];
    return  strUrl;
    
}
@end
