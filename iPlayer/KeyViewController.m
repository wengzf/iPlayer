//
//  KeyViewController.m
//  iPlayer
//
//  Created by 翁志方 on 16/6/25.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "KeyViewController.h"
#import "FSNetworkManager.h"
#import <objc/runtime.h>

#import "LMAppController.h"
#import "YingYongYuanetapplicationDSID.h"


#import "CocoaAsyncSocket.h"
#import "GNASocket.h"



@interface KeyViewController ()<GCDAsyncSocketDelegate>

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
    
    NSArray * apps = [LMAppController sharedInstance].inApplications;
    NSInteger state = [[YingYongYuanetapplicationDSID sharedInstance] getAppState:@"com.baidu.waldet"];
    

}



- (IBAction)backBtnClked:(id)sender {
    
    // 打开赚么网页
    NSURL *url = [NSURL URLWithString:@"http://www.shoujizhuan.com.cn/load"];
    [[UIApplication sharedApplication] openURL:url];
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

    
    NSString *innerContent = @"{\"type\":3}";
    
    
//    NSString *innerContent = @"Has received";
    
    NSData *fileData = [innerContent dataUsingEncoding:NSUTF8StringEncoding];

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

// 接收消息
- (IBAction)receiveMassage:(UIButton *)sender
{
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    
    [self sendMessage:nil];
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
    // short: %hd
    // unsigned short: %hu
    
    // 存储新的端口号
    self.clientSocket = newSocket;
    
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    
    
    [self sendMessage:nil];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self addText:message];
}


#pragma mark - socket 通信

- (void)login
{
    // 调用打开app接口
    [FSNetworkManagerDefaultInstance loginWithIDFAStr:Global.idfa
                                         successBlock:^(long status, NSDictionary *dic) {
                                             
                                             // 打开赚么网页
                                             NSURL *url = [NSURL URLWithString:@"http://www.shoujizhuan.com.cn/load"];
                                             [[UIApplication sharedApplication] openURL:url];
                                         }];
}
- (void)share
{
    
}



@end
