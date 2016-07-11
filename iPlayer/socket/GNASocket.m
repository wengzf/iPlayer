//
//  GNASocket.m
//  SocketTest
//
//  Created by 翁志方 on 16/7/7.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "GNASocket.h"

@implementation GNASocket

+ (GNASocket *)defaultScocket
{
    static GNASocket *socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [[GNASocket alloc] init];
    });
    return socket;
}

@end