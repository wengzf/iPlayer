//
//  SocketClient.m
//  iPlayer
//
//  Created by 翁志方 on 16/8/9.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "SocketClient.h"

@implementation SocketClient

- (instancetype)init
{
    self = [super init];
    
    NSURL *url = [NSURL URLWithString:@"ws://127.0.0.1:555"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.client = [PSWebSocket clientSocketWithRequest:request];
    self.client.delegate = self;
    [self.client open];

    return self;
}


- (void)sendMessage:(NSString *)content
{
    if (self.client.readyState == PSWebSocketReadyStateOpen) {
        
        [self.client send:content];
    }else{
        NSLog(@"client socket 未连接");
    }
}

#pragma mark -
- (void)webSocketDidOpen:(PSWebSocket *)webSocket
{
    
}
- (void)webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error
{
    
}
- (void)webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Client %@",message);
    
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
    NSInteger status = [dict[@"code"] integerValue];
    if (status == 1000) {
        // 在线
        
        
    }
}
- (void)webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Client close %@",reason);
}


@end
