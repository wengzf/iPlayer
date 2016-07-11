//
//  WjAppInfo.m
//  IosAdSdk
//
//  Created by xqzhang on 16/2/22.
//  Copyright © 2016年 IosAdSdk. All rights reserved.
//

#import "YingYongYuanjAppInfo.h"

@implementation YingYongYuanjAppInfo static YingYongYuanjAppInfo *instance = nil;

+ (YingYongYuanjAppInfo *) getInstance{
    
    @synchronized (self)
    {
        if (instance == nil)
        {
            Class clazz = NSClassFromString(@"YingYongYuanjAppInfoTest");
            instance  = [[clazz alloc] init];
        }
    }
    return instance;
}
@end
