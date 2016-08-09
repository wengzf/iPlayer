//
//  SocketClient.h
//  iPlayer
//
//  Created by 翁志方 on 16/8/9.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PSWebSocket.h"


@interface SocketClient : NSObject<PSWebSocketDelegate>

@property (nonatomic, strong) PSWebSocket *client;

- (void)sendMessage:(NSString *)content;


@end
