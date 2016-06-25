//
//  GlobalVar.m
//  WhiteSharkBusiness
//
//  Created by wzf_taker on 15/12/25.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "GlobalVar.h"

@interface GlobalVar()
{
}

@end


@implementation GlobalVar


static GlobalVar *obj;

+ (GlobalVar *)shareInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[GlobalVar alloc] init];

        [obj refreshUserInfo];
    });
    return obj;
}



// 跳转到支付页面


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


#pragma mark - 数据同步

- (void)refreshUserInfo
{
    self.token = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalToken];
    self.isLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:kGlobalIsLogin] boolValue];
    self.deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalDeviceToken];
    self.userID = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalUserID];
    self.zhifubaoAccount = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalZhifubaoAccount];
    self.qqAccount = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalQQAccount];
    self.huafeiAccount = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalHuafeiAccount];
    
    self.name     = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalName];
    self.mail     = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalMail];
    self.phone    = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalPhone];
    self.conis    = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalCoins];
    
    self.status   = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalStatus];
    
    self.nation    = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalNation];
    self.app_name    = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalApp_name];
    self.app_version   = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalApp_version];
    
    self.platform = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalPlatform];
}
- (void)saveUserInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:kGlobalToken];
    [[NSUserDefaults standardUserDefaults] setBool:self.isLogin forKey:kGlobalIsLogin];
    [[NSUserDefaults standardUserDefaults] setObject:self.deviceToken forKey:kGlobalDeviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:kGlobalUserID];
    [[NSUserDefaults standardUserDefaults] setObject:self.zhifubaoAccount forKey:kGlobalZhifubaoAccount];
    [[NSUserDefaults standardUserDefaults] setObject:self.qqAccount forKey:kGlobalQQAccount];
    [[NSUserDefaults standardUserDefaults] setObject:self.huafeiAccount forKey:kGlobalHuafeiAccount];

    
    [[NSUserDefaults standardUserDefaults] setObject:self.name forKey:kGlobalName];
    [[NSUserDefaults standardUserDefaults] setObject:self.mail forKey:kGlobalMail];
    [[NSUserDefaults standardUserDefaults] setObject:self.phone forKey:kGlobalPhone];
    [[NSUserDefaults standardUserDefaults] setObject:self.conis forKey:kGlobalCoins];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.status forKey:kGlobalStatus];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.nation forKey:kGlobalNation];
    [[NSUserDefaults standardUserDefaults] setObject:self.app_name forKey:kGlobalApp_name];
    [[NSUserDefaults standardUserDefaults] setObject:self.app_version forKey:kGlobalApp_version];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.platform forKey:kGlobalPlatform];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)clearUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalIsLogin];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalDeviceToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalUserID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalZhifubaoAccount];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalQQAccount];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalHuafeiAccount];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalMail];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalPhone];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalCoins];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalStatus];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalNation];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalApp_name];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalApp_version];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGlobalPlatform];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
