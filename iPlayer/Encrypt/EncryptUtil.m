//
//  EncryptUtil.m
//  gannicus
//
//  Created by Zhu Boxing on 13-7-15.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import "EncryptUtil.h"

#define encryptDesKey   @"8daluqp9xm2kw6zs1hta"
//#define encryptDesKey   @"5C2mYv6fkCtTDUNNAVcM9ess3ffRDDUTUKzb"

@implementation EncryptUtil

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *vplainText;  //内存泄漏被注
    size_t plainTextBufferSize;
    
    if (encryptOperation == kCCDecrypt)
    {
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [decryptData length];
        vplainText = [decryptData bytes];//内存泄漏被注
    } else {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [encryptData length];
        vplainText = (const void *)[encryptData bytes];//内存泄漏被注
    }
    
    CCCryptorStatus ccStatus;//内存泄漏被注
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    uint8_t *bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    //const void *vkey = (const void *) [DESKEY UTF8String];
    // 24位KEY
    if (key.length != 24) {
        for (int i = 0; key.length <= 24; i++) {
            key = [key stringByAppendingString:@"0"];
        }
    }//kCCOptionPKCS7Padding
    //内存泄漏被注
    ccStatus = CCCrypt(encryptOperation,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding | kCCOptionECBMode,
            [key UTF8String],
            kCCKeySize3DES,
            nil,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    /*if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    else if (ccStatus == kCCParamError) return @"PARAM ERROR";
    else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
    else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
    else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
    else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
    else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
    */
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    } else {
        NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:data];
    }
    free(bufferPtr);
    return result;
}

+ (NSString *)encryptWithText:(NSString *)sText
{
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:encryptDesKey];
}

+ (NSString *)decryptWithText:(NSString *)sText
{
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:encryptDesKey];
}

+ (NSString *)encryptTextWithKey:(NSString *)sText key:(NSString *) key
{
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:key];
}

+ (NSString *)decryptTextWithKey:(NSString *)sText key:(NSString *) key
{
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:key];
}

@end
