//
//  KeyChainUtil.h
//  gannicus
//
//  Created by Zhu Boxing on 13-7-11.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface KeyChainUtil : NSObject

/**
 *  @brief  存储数据
 *  @param  value 数据内容
 *  @param  key 数据键值
 */
+(void)saveKeyChain:(NSObject *)value forKey:(NSString *)key;

/**
 *  @brief  读取数据
 *  @return 数据内容
 */
+(id)readKeyChain:(NSString *)key;

/**
 *  @brief  删除数据
 */
+(void)deleteKeyChain:(NSString *)key;

@end
