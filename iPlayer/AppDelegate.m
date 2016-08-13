//
//  AppDelegate.m
//  iPlayer
//
//  Created by 翁志方 on 15/12/5.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "AppDelegate.h"
#import "KeyChainUtil.h"
#import <AdSupport/AdSupport.h>
#import <SMS_SDK/SMSSDK.h>                              // 短信
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>

#import <ShareSDK/ShareSDK.h>                       // 分享
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"
#import "WeiboSDK.h"

#import "KeyViewController.h"

#import "JPUSHService.h"            // 推送

#import "UMMobClick/MobClick.h"     //  友盟

@interface AppDelegate ()
{
    AVAudioPlayer *player;
    NSTimer *timer;
    
    NSURL *appScheme;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // 从keychain中获取 IDFA
    NSString *idfa = [KeyChainUtil readKeyChain:@"idfa"];
    if (idfa == nil || [idfa isEqual:[NSNull null]]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
#else
        CFUUIDRef deviceId = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef deviceIdStringRef = CFUUIDCreateString(NULL, deviceId);
        idfa = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, deviceIdStringRef));
        CFRelease(deviceId);
        CFRelease(deviceIdStringRef);
#endif
        [KeyChainUtil saveKeyChain:idfa forKey:@"idfa"];
    }
    Global.idfa = idfa;
    [Global saveUserInfo];

    // 短信初始化  iplayer
//    {
//        NSString *appKey = @"154dc5b58f49c";
//        NSString *appSecret = @"383194863edddfb73d5d3dab27730c34";
//        [SMSSDK registerApp:appKey withSecret:appSecret];
//    }
    
    // 友盟统计 57aeabede0f55a7d5a0015bb
    {
        [MobClick setLogEnabled:YES];
        UMConfigInstance.appKey = @"57aeabede0f55a7d5a0015bb";
//        UMConfigInstance.secret = @"secretstringaldfkals";
        [MobClick startWithConfigure:UMConfigInstance];
    }
    
    
    // 短信初始化
    {
        NSString *appKey = @"11251bfa2495c";              // CashMaker
        NSString *appSecret = @"2ec864e58957d6f61bcc705b80324168";
        [SMSSDK registerApp:appKey withSecret:appSecret];
        [SMSSDK enableAppContactFriends:NO];
    }
    
    // 极光推送初始化
    {
        //        dc0dddfc8beb393b21fa6cbe      AppKey
        //        57a325412acebaee091c3eaf      MasterSecret
        NSString *advertisingId = nil;
        
        static NSString *appKey = @"dc0dddfc8beb393b21fa6cbe";
        static NSString *channel = @"Publish channel";
        static BOOL isProduction = FALSE;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //可以添加自定义categories
            [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                              UIUserNotificationTypeSound |
                                                              UIUserNotificationTypeAlert)
                                                  categories:nil];
        } else {
            //categories 必须为nil
            [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                              UIRemoteNotificationTypeSound |
                                                              UIRemoteNotificationTypeAlert)
                                                  categories:nil];
        }
        
        //如不需要使用IDFA，advertisingIdentifier 可为nil
        [JPUSHService setupWithOption:launchOptions appKey:appKey
                              channel:channel
                     apsForProduction:isProduction
                advertisingIdentifier:advertisingId];
    }

    // 分享初始化
    {
        /**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
         *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */
        
        [ShareSDK registerApp:@"15ebd87594b1f"          // 音乐练习
              activePlatforms:@[
                                @(SSDKPlatformTypeSinaWeibo),
                                @(SSDKPlatformTypeWechat),
                                @(SSDKPlatformTypeQQ)
                                ]
                     onImport:^(SSDKPlatformType platformType) {
                         
                         switch (platformType)
                         {
                             case SSDKPlatformTypeWechat:
                                 //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                                 [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                 break;
                             case SSDKPlatformTypeQQ:
                                 [ShareSDKConnector connectQQ:[QQApiInterface class]
                                            tencentOAuthClass:[TencentOAuth class]];
                                 break;
                             case SSDKPlatformTypeSinaWeibo:
                                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                 break;
                                 
                             default:
                                 break;
                         }
                     }
              onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                  
                  switch (platformType)
                  {
                      case SSDKPlatformTypeSinaWeibo:
                          //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                          [appInfo SSDKSetupSinaWeiboByAppKey:@"3721086158"
                                                    appSecret:@"c39b2b8e021b74ef4234e79dff20d773"
                                                  redirectUri:@"http://www.sharesdk.cn"
                                                     authType:SSDKAuthTypeBoth];
                          break;
                          
                      case SSDKPlatformTypeWechat:
                          [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                                appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                          break;
                      case SSDKPlatformTypeQQ:
                          [appInfo SSDKSetupQQByAppId:@"100371282"                  // QQ
                                               appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                             authType:SSDKAuthTypeBoth];
                          break;
                      default:
                          break;
                  }
              }];
    }
    
    // 播放音频，开启永久后台模式
    [self playAudio];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.

}

// 永久后台模式
- (void) playAudio
{
    //初始化并开启音频播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *categoryError = nil;
    NSError *activeError = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&categoryError];
    if (!categoryError) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruptionAudio:) name:AVAudioSessionInterruptionNotification object:audioSession];
        [audioSession setActive:YES error:&activeError];
        if (!activeError) {
            NSError *dataError = nil;
            NSData *audioData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ALARM1" withExtension:@".WAV"]];
            player = [[AVAudioPlayer alloc] initWithData:audioData error:&dataError];
            if (!dataError) {
                [player setVolume:0];
                player.numberOfLoops = -1;
                [player prepareToPlay];
                [player play];
            }
        }
    }
}
//处理音频播放的各种中断时间，比如电话，其它音频app等导致的音频播放中断问题
- (void)handleInterruptionAudio:(NSNotification *)notification {
    NSLog(@"interrupt%@",notification.description);
    NSDictionary *userDic = notification.userInfo;
    if ([userDic[AVAudioSessionInterruptionTypeKey] intValue] == 0) {
        //end
        if ([userDic[AVAudioSessionInterruptionOptionKey] intValue] == AVAudioSessionInterruptionOptionShouldResume) {
            [player prepareToPlay];
            [player play];
        }
    }
    if ([userDic[AVAudioSessionInterruptionTypeKey] intValue] == 1) {
        //begin
        [player pause];
    }
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSString *urlStr = [url absoluteString];
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

#pragma mark - 极光推送

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

@end
