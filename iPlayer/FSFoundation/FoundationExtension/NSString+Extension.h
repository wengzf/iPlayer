//
//  NSString+Extension.h
//  WhiteSharkBusiness
//
//  Created by 翁志方 on 16/1/5.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

// 时间
+ (NSString *)stringWithTimeInterval:(NSTimeInterval) interval;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)getelapsedTimeWith:(NSString *)date;
- (NSString *)usualTimeString;
- (NSTimeInterval)retuenTheSecondNowToTime;




- (NSString *)moneyString;          // 数字字符串转成带‘，’的金额字符串
- (float)stringFormaterToFloat:(NSString *)string; //带逗号的钱数 转化 成float

- (NSDate *)toDate;                 // 字符串转换成时间 2015-12-25 12:39:29


@end


@interface NSString (TrimmingAdditions)
- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet ;
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet ;
@end
