//
//  GNASocket.h
//  SocketTest
//
//  Created by 翁志方 on 16/7/7.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaAsyncSocket.h"

@interface GNASocket : NSObject

@property (nonatomic, strong) GCDAsyncSocket *mySocket;

+ (GNASocket *)defaultScocket;

@end