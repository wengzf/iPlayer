//
//  KeyChainUtil.m
//  gannicus
//
//  Created by Zhu Boxing on 13-7-11.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import "KeyChainUtil.h"

@implementation KeyChainUtil

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

/**
 *  @brief  存储数据
 *  @param  value 数据内容
 */
+(void)saveKeyChain:(NSObject *)value forKey:(NSString *)key {
    NSMutableDictionary *saveKVPairs = [NSMutableDictionary dictionary];
    [saveKVPairs setObject:value forKey:key];
    [self save:key data:saveKVPairs];
}

/**
 *  @brief  读取数据
 *  @return 数据内容
 */
+(id)readKeyChain:(NSString *) key {
    NSMutableDictionary *readKVPair = (NSMutableDictionary *)[self load:key];
    
    return [readKVPair objectForKey:key];
}

/**
 *  @brief  删除数据
 */
+(void)deleteKeyChain:(NSString *)key {
    [KeyChainUtil delete:key];
}

@end
