//
//  KeyViewController.m
//  iPlayer
//
//  Created by 翁志方 on 16/6/25.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "KeyViewController.h"

#import <SMS_SDK/SMSSDK.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>


#import "PSWebSocketServer.h"

#import "FSNetworkManager.h"
#import <objc/runtime.h>

#import "LMAppController.h"
#import "YingYongYuanetapplicationDSID.h"

#import "JailBrokenClass.h"

@interface KeyViewController ()<PSWebSocketServerDelegate>
{
    NSString *curAppBundleid;        // 需要检查的bundleid列表
    NSString *curTaskid;
    NSString *curAppName;
    NSDate *curAppOpenTime;             // 任务打开时间
    
}

@property (nonatomic, strong) PSWebSocketServer *server;

@end


@implementation KeyViewController

- (void)viewDidLoad
{
    // 开始赚钱圆角边框
    [self.backBtn setRoundCornerWithColor:[UIColor whiteColor] radius:6 width:1];
    self.backBtn.layer.masksToBounds = YES;
    
    // 检查越狱
    if ([JailBrokenClass isJailbroken]) {
        self.titleLabel.text = @"请在非越狱设备上完成任务";
        self.contentLabel.text = @"";
        
        //
        self.backBtn.hidden = YES;
    }else{
        // 开始监听本地端口
        [self initServer:555];
        
        // 检查app
        curAppBundleid = @"";
        curTaskid = @"";
        
    }
    
    
    // 调用登录接口
    
    if (Global.userID == nil){
        [FSNetworkManagerDefaultInstance loginWithIDFAStr:Global.idfa successBlock:^(long status, NSDictionary *dic) {
            
            Global.token = dic[@"data"][@"token"];
            Global.userID = dic[@"data"][@"userid"];
            [Global saveUserInfo];
        }];
    }

    
}
-(void)initServer:(int) port{
    
    self.server = [PSWebSocketServer serverWithHost:@"127.0.0.1" port:port];
    self.server.delegate = self;
    [self.server start];
}

#pragma mark - PSWebSocketServerDelegate
- (void)serverDidStart:(PSWebSocketServer *)server {
    NSLog(@"serverDidStart");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //干点啥 通知 启动了
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeLabel" object:nil];
    });
}
- (void)serverDidStop:(PSWebSocketServer *)server {
    NSLog(@"serverDidStop");
    
//    errorCount++;
//    if(errorCount > 3){
//        //连接失败
//        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"服务器连接超时，请重新打开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
//        return ;
//    }
    
    [self initServer:555];
    
}

- (void)server:(PSWebSocketServer *)server webSocketDidOpen:(PSWebSocket *)webSocket {
}
#pragma 接收到指令 要干啥
- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message {
    @try
    {
        NSLog(@"%@",message);
        
        NSData * requestData = nil;
        NSString * requestStr = nil ;
        
        if([message isKindOfClass: [ NSData class ]]){
            requestData = message;
            requestStr  =[[ NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
            
        }else{
            requestStr = message;
            requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding] ;
        }
        
        NSError *resErr = nil;
        
        NSDictionary * dict=[NSJSONSerialization JSONObjectWithData: requestData options:0 error:&resErr];
        NSString * status=[dict objectForKey:@"status"];
        NSString * path=[dict objectForKey:@"path"];
        NSDictionary *params=[dict objectForKey:@"params"];
        
        
        if ([status isEqualToString:@"0"]) {
            [self.view showLoadingWithMessage:@"哎呀，服务器开小差了!" hideAfter:2];
        }else {
            if ([path isEqualToString:@"c/app/isopen"]) {
            
                [self writeWebMsg:webSocket msg:@"{\"code\":1000}"];
                
            }else if ([path isEqualToString:@"c/app/login"]) {
                // 登录
                [FSNetworkManagerDefaultInstance loginWithIDFAStr:Global.idfa successBlock:^(long status, NSDictionary *dic) {
                    Global.token = dic[@"data"][@"token"];
                    Global.userID = dic[@"data"][@"userid"];
                    [Global saveUserInfo];
                    
                    NSString *str = [NSString stringWithFormat:@"{\"code\":1000, \"data\":{\"token\":\"%@\"}}",Global.token];
                    [self writeWebMsg:webSocket msg:str];
                }];
                
            }else if ([path isEqualToString:@"c/task/copyKeywords"]) {
                // 复制关键字
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = params[@"keywords"];
                
                [self writeWebMsg:webSocket msg:@"{\"code\":1000}"];
                
            }else if ([path isEqualToString:@"c/task/openApp"]) {
                // 检查是否安装app，并打开
                
                curAppBundleid = params[@"bundleid"];
                NSInteger state = [[YingYongYuanetapplicationDSID sharedInstance] getAppState:curAppBundleid];
                if (state) {
                    curAppOpenTime = [NSDate date];
                    
                    [[LMAppController sharedInstance] openAppWithBundleIdentifier:curAppBundleid];
                    
                    [self writeWebMsg:webSocket msg:@"{\"code\":1000}"];
                }else{
                    [self writeWebMsg:webSocket msg:@"{\"code\":1001,\"message\":\"请下载任务APP\"}"];
                }
                
            }else if ([path isEqualToString:@"c/task/complete"]) {
                // 检查是否成功完成任务
                int time = [[NSDate date] timeIntervalSinceDate:curAppOpenTime];
                
                if (time<60) {
                    
                    NSString *content = [NSString stringWithFormat:@"{\"code\":1001,\"message\":\"请按照要求再试玩%d秒\"}", 180-time];
                    [self writeWebMsg:webSocket msg:content];
                    
                    // 未完成任务，自动打开app
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [[LMAppController sharedInstance] openAppWithBundleIdentifier:curAppBundleid];
                        
                    });
                }else{
                    // 调用完成任务接口
                    NSDictionary *parameterDic = @{@"userid":Global.userID,@"taskid":curTaskid};
                    curTaskid = params[@"taskid"];
                    [FSNetworkManagerDefaultInstance POST:@"c/task/complete" parameters:parameterDic success:^(NSDictionary *responseDic, id responseObject) {
                        
                        if ([responseDic[@"code"] intValue] == 1000) {
                            
                            [self writeWebMsg:webSocket msg:@"{\"code\":1000}"];
                            
                            [self registerLocalNotification:1 content:@"当前任务已完成"];
                        }
                        
                    } failure:^(NSError *error) {
                    }];
                }
                
            }else if ([path isEqualToString:@"c/signin/share"]) {
                // 分享接口
                [[LMAppController sharedInstance] openAppWithBundleIdentifier:@"com.yonglibao.FireShadowTest"];
                
//                [[LMAppController sharedInstance] openAppWithBundleIdentifier:@"com.wzf.player"];
                
                
                [self shareWithSource:@"1"];
                
            }else if ([path isEqualToString:@"c/sms/send"]) {
                // 发送短信
                NSString *mobile = params[@"mobile"];
                [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:mobile zone:@"86" customIdentifier:nil result:^(NSError *error) {
                    
                    if (!error) {
                        [self writeWebMsg:webSocket msg:@"{\"code\":1000}"];
                    }else{
                        NSString *str = [NSString stringWithFormat:@"{\"code\":1001,\"message\":\"%@\"}",error.userInfo[@"commitVerificationCode"]];
                        [self writeWebMsg:webSocket msg:str];
                    }
                    
                }];
                
            }else if ([path isEqualToString:@"c/sms/valid"]) {
                // 发送短信
                NSString *mobile = params[@"mobile"];
                NSString *ver = params[@"code"];
                [SMSSDK commitVerificationCode:ver phoneNumber:mobile zone:@"86" result:^(NSError *error) {
                    
                    if (!error) {
                        [self writeWebMsg:webSocket msg:@"{\"code\":1000}"];
                    }
                    else
                    {
                        NSString *str = [NSString stringWithFormat:@"{\"code\":1001,\"message\":\"%@\"}",@"验证码错误"];
                        [self writeWebMsg:webSocket msg:str];
                    }
                }];
                
            }else {
                // 路由接口，请求后端数据并返回
                NSMutableDictionary *parameterDic = [NSMutableDictionary dictionaryWithDictionary:params];
                [parameterDic setObject:Global.userID forKey:@"userid"];
                
                [FSNetworkManagerDefaultInstance POST:path parameters:parameterDic success:^(NSDictionary *responseDic, id responseObject) {
                    
                    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    NSLog(@"%@  message:%@",str,responseDic[@"message"]);
                    if ([path isEqualToString:@"c/task/receive"]) {
                        // 做任务
                        curAppBundleid = responseDic[@"data"][@"bundle_id"];
                        curAppName = responseDic[@"data"][@"app_name"];
                        curTaskid = parameterDic[@"taskid"];
                        
                    }else if ([path isEqualToString:@"c/task/drop"]) {
                        // 放弃任务
                        curAppBundleid = @"";
                        curTaskid = @"";
                        
                    }else if ([path isEqualToString:@"c/user/switchAccount"]) {
                        
                        // 切换账号
                        Global.token = params[@"token"];
                        Global.userID = params[@"userid"];
                        [Global saveUserInfo];
                        
                        curAppBundleid = @"";
                        curTaskid = @"";
                        curAppOpenTime = nil;
                    }
                    
                    [self writeWebMsg:webSocket msg:str];
                    
                } failure:^(NSError *error) {
                }];
            }
            
        }
    } @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        
    }
}
-(void) writeWebMsg:(PSWebSocket *) client msg:(NSString *)msg{
    if(msg == nil || client == nil){
        return;
    }
    [client send:msg];
}
- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error {
}
- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
}

#pragma mark - 事件
// 跳到网页端登录
- (IBAction)backBtnClked:(id)sender {
    // 调用登录接口
    [self.view showLoading];
    [FSNetworkManagerDefaultInstance loginWithIDFAStr:Global.idfa successBlock:^(long status, NSDictionary *dic) {
        [self.view hideLoading];
        
        Global.token = dic[@"data"][@"token"];
        Global.userID = dic[@"data"][@"userid"];
        [Global saveUserInfo];
        
        // 打开赚么网页
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.shoujizhuan.com.cn/load?token=%@",Global.token] ];
        [[UIApplication sharedApplication] openURL:url];
        
    }];
}

#pragma mark - socket 通信

- (void)shareWithSource:(NSString *)source
{
    // 告诉Web端已经开始分享
    [self showShareActionSheet:self.view source:source];
}

#pragma mark - 工具方法
- (NSDictionary *)parseUrlParams:(NSString *)query
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [[query componentsSeparatedByString:@"&"]
     enumerateObjectsUsingBlock:^(NSString *pair, NSUInteger idx, BOOL *stop) {
         NSArray *keyValue = [pair componentsSeparatedByString:@"="];
         if (keyValue.count < 2) {
             return;
         }
         NSString *key = [keyValue[0] stringByRemovingPercentEncoding];
         NSString *value = [keyValue[1] stringByRemovingPercentEncoding];
         if (key.length == 0 || value.length == 0) {
             return;
         }
         parameters[key] = value;
     }];
    return [parameters copy];
    
}

#pragma mark - 本地通知
// 设置本地通知
- (void)registerLocalNotification:(NSInteger)alertTime content:(NSString*)content{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    // 通知内容
    notification.alertBody = content;
    
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;

    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark 显示分享菜单
/**
 *  显示分享菜单
 *
 *  @param view 容器视图
 */
- (void)showShareActionSheet:(UIView *)view source:(NSString *)source
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSString *content = @"试玩最新应用，日入几十，月入上千，让轻松赚钱变成习惯。";
    NSArray* imageArray = @[[UIImage imageNamed:@"icon_60"]];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:@"http://shoujizhuan.me/"]
                                      title:@"有手机 随时赚外快"
                                       type:SSDKContentTypeAuto];
    
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    //添加一个自定义的平台（非必要）
    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
                                                                                  label:@"自定义"
                                                                                onClick:^{
                                                                                    
                                                                                    //自定义item被点击的处理逻辑
                                                                                    NSLog(@"=== 自定义item被点击 ===");
                                                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"自定义item被点击"
                                                                                                                                        message:nil
                                                                                                                                       delegate:nil
                                                                                                                              cancelButtonTitle:@"确定"
                                                                                                                              otherButtonTitles:nil];
                                                                                    [alertView show];
                                                                                }];
    [activePlatforms addObject:item];
    //2、分享
    [ShareSDK showShareActionSheet:view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           //                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeFacebookMessenger)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           
                           
                           NSString *platformStr = @"1";
                           switch (platformType) {
                               case SSDKPlatformTypeSinaWeibo:
                                   platformStr = @"1";
                                   break;
                               case SSDKPlatformTypeWechat:
                                   platformStr = @"2";
                                   break;
                               case SSDKPlatformTypeQQ:
                                   platformStr = @"3";
                                   break;
                                   
                               default:
                                   break;
                           }
                           
                           NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
                           [parameterDic setObject:Global.userID forKey:@"userid"];
                           [FSNetworkManagerDefaultInstance POST:@"c/signin/share" parameters:parameterDic success:^(NSDictionary *responseDic, id responseObject) {
                               
                               
                           } failure:^(NSError *error) {
                           }];
                           
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           //                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                           //                                                                               message:nil
                           //                                                                              delegate:nil
                           //                                                                     cancelButtonTitle:@"确定"
                           //                                                                     otherButtonTitles:nil];
                           //                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
               }];
    
    //另附：设置跳过分享编辑页面，直接分享的平台。
    //        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
    //                                                                         items:nil
    //                                                                   shareParams:shareParams
    //                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
    //                                                           }];
    //
    //        //删除和添加平台示例
    //        [sheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
    //        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    
}

@end
