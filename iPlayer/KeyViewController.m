//
//  KeyViewController.m
//  iPlayer
//
//  Created by 翁志方 on 16/6/25.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "KeyViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>


#import "FSNetworkManager.h"
#import <objc/runtime.h>

#import "LMAppController.h"
#import "YingYongYuanetapplicationDSID.h"


#import "CocoaAsyncSocket.h"
#import "GNASocket.h"




@interface KeyViewController ()<GCDAsyncSocketDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextView *message; // 多行文本输入框
@property (weak, nonatomic) IBOutlet UITextField *content;


@property (weak, nonatomic) IBOutlet UIButton *listenBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;


@property (nonatomic, strong) GCDAsyncSocket *clientSocket; // 为客户端生成的socket

@property (nonatomic, strong) GCDAsyncSocket *serverSocket; // 服务器socket


@end


@implementation KeyViewController


+ (KeyViewController *)shareInstance
{
    static KeyViewController *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[KeyViewController alloc] init];
    });
    
    return obj;
}


- (void)show
{
    self.view.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
}

- (void)viewDidLoad
{
    self.backBtn.layer.cornerRadius = 4;
    self.backBtn.layer.masksToBounds = YES;

    // 开始监听接口
    [self listen:nil];
}

- (IBAction)backBtnClked:(id)sender {
    // 调用登录接口
    [FSNetworkManagerDefaultInstance loginWithIDFAStr:Global.idfa successBlock:^(long status, NSDictionary *dic) {
        Global.token = dic[@"data"][@"token"];
        if ([dic[@"data"][@"show"] intValue] == 1) {
            // 打开赚么网页
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.shoujizhuan.com.cn/load?token=%@",Global.token] ];
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
}

// 服务端监听某个端口
- (IBAction)listen:(UIButton *)sender
{
    // 1. 创建服务器socket
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 2. 开放哪些端口
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:self.portTF.text.integerValue error:&error];
    
    // 3. 判断端口号是否开放成功
    if (result) {
        [self addText:@"端口开放成功"];
    } else {
        [self addText:@"端口开放失败"];
    }
}

// 发送
- (IBAction)sendMessage:(UIButton *)sender
{
//    状态行：包含了HTTP协议版本、状态码、状态英文名称
//    
//    HTTP/1.1 200 OK
//    
//    响应头：包含了对服务器的描述、对返回数据的描述
//    
//Server: Apache-Coyote/1.1 // 服务器的类型
//    
//    Content-Type: image/jpeg // 返回数据的类型
//    
//    Content-Length: 56811 // 返回数据的长度
//    
//Date: Mon, 23 Jun 2014 12:54:52 GMT // 响应的时间
//    
//    实体内容：服务器返回给客户端的具体数据，比如文件数据
}

// 接收消息
- (IBAction)receiveMassage:(UIButton *)sender
{
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

// textView填写内容
- (void)addText:(NSString *)text
{
    self.message.text = [self.message.text stringByAppendingFormat:@"%@\n", text];
}

#pragma mark - GCDAsyncSocketDelegate
// 当客户端链接服务器端的socket, 为客户端单生成一个socket
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    [self addText:@"链接成功"];
    [self addText:[NSString stringWithFormat:@"链接地址:%@", newSocket.connectedHost]];
    [self addText:[NSString stringWithFormat:@"端口号:%hu", newSocket.connectedPort]];
    
    // 存储新的端口号
    self.clientSocket = newSocket;
    
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self addText:message];
    
    // 收到http请求协议报文

    NSRange rangeSt = [message rangeOfString:@"GET /?"];
    NSRange rangeEd = [message rangeOfString:@"HTTP/1.1"];
    
    NSRange range;
    range.location = rangeSt.location+rangeSt.length;
    range.length = rangeEd.location - range.location;
    NSString *queryStr = [message substringWithRange:range];
    
    queryStr = [queryStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 开始解析参数
    NSDictionary *dic = [self parseUrlParams:queryStr];
    
    if ([dic[@"m"] isEqualToString:@"login"]){
        [self login];
    }else if ([dic[@"m"] isEqualToString:@"share"]){
        
        id obj = dic[@"source"];
        NSString *source;
        if ([obj isKindOfClass:[NSNumber class]]) {
            source = [obj stringValue];
        }else{
            source = obj;
        }
        
        [self shareWithSource:source];
    }else if ([dic[@"m"] isEqualToString:@"checkInstall"]){
        [self checkInstallAppWithBundleID:dic[@"bundleID"]];
    }
}

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

#pragma mark - socket 通信
- (void)login
{
    // 调用登录接口
    [FSNetworkManagerDefaultInstance loginWithIDFAStr:Global.idfa successBlock:^(long status, NSDictionary *dic) {
        Global.token = dic[@"data"][@"token"];
        if ([dic[@"data"][@"show"] intValue] == 1) {
            // 回复socket登录
            NSString *content = [NSString stringWithFormat:@"{token:\"%@\"}",Global.token];
            [self answerRequestWithContent:content];
        }
    }];
}
- (void)shareWithSource:(NSString *)source
{
    // 告诉Web端已经开始分享
    [self showShareActionSheet:self.view source:source];
}
- (void)checkInstallAppWithBundleID:(NSString *)bundleID
{
    //0 未安装  1安装 2运行  ios9以上不能获取运行
    NSInteger state = [[YingYongYuanetapplicationDSID sharedInstance] getAppState:bundleID];
    
    NSString *content = [NSString stringWithFormat:@"{\"flagInstall\":%ld}",(long)state];
    [self answerRequestWithContent:content];
}


- (void)answerRequestWithContent:(NSString *)content
{
    NSData *fileData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    CFHTTPMessageRef response;
    
    response = CFHTTPMessageCreateResponse(kCFAllocatorDefault,
                                           200,
                                           NULL,
                                           kCFHTTPVersion1_1);
    
    //    CFHTTPMessageSetHeaderFieldValue(response,
    //                                     (CFStringRef)@"Content-Type",
    //                                     (CFStringRef)@"text/plain");
    CFHTTPMessageSetHeaderFieldValue(response,
                                     (CFStringRef)@"Content-Type",
                                     (CFStringRef)@"application/json");
    
    CFHTTPMessageSetHeaderFieldValue(response,
                                     (CFStringRef)@"Connection",
                                     (CFStringRef)@"close");
    
    CFHTTPMessageSetHeaderFieldValue(response,
                                     (CFStringRef)@"Content-Length",
                                     (__bridge CFStringRef)[NSString stringWithFormat:@"%ld", [fileData length]]);
    
    CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);
    
    
    
    
    NSMutableData *data = [NSMutableData dataWithData:(__bridge NSData*)headerData];
    
    [data appendData:fileData];
    
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
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
    NSArray* imageArray = @[[UIImage imageNamed:@"icon_40"]];
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
                           
                           [FSNetworkManagerDefaultInstance shareWithIDFAStr:Global.idfa source:source successBlock:^(long status, NSDictionary *dic) {
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
