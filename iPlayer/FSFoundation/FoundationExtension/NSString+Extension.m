//
//  NSString+Extension.m
//  WhiteSharkBusiness
//
//  Created by 翁志方 on 16/1/5.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


// 时间
+ (NSString *)stringWithTimeInterval:(NSTimeInterval) interval
{
    int tmp = interval;
    int hour = tmp / 3600;
    int minute = tmp % 3600 / 60;
    int second = tmp % 60;

    NSMutableString *str = [NSMutableString string];
    if (hour) {
        [str appendString:[NSString stringWithFormat:@"%d小时",hour]];
    }
    if (minute) {
        [str appendString:[NSString stringWithFormat:@"%d分钟",minute]];
    }
    if (second) {
        [str appendString:[NSString stringWithFormat:@"%d秒",second]];
    }
    
    return str;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    if (IsIOS7) {
        return [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByTruncatingTail];
    }else{
        NSDictionary *attrs = @{NSFontAttributeName : font};
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }
}

+ (NSString *)getelapsedTimeWith:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *time                   = [dateFormatter dateFromString:date];
    NSTimeInterval second          = [[NSDate date]timeIntervalSinceDate:time];
    
    if (second >= 0 && second <= 60) {
        return @"刚刚";
    }else if (second > 60 && second < 3600){
        return [NSString stringWithFormat:@"%d分钟前",(int)second/60];
    }else if (second >= 3600 && second < 86400){
        return [NSString stringWithFormat:@"%d小时前",(int)second/3600];
    }else if (second >= 86400 && second < 86400 * 2){
        return @"昨天";
    }else if (second >= 86400*2 && second < 86400 * 3){
        return @"前天";
    }else if (second >= 86400*3 && second < 86400 * 30){
        return [NSString stringWithFormat:@"%d天前",(int)second/86400];
    }else if (second >= 86400 *30 && second < 86400 * 365){
        return [NSString stringWithFormat:@"%d月前",(int)second/(86400 * 30)];
    }else{
        return [NSString stringWithFormat:@"%d年前",(int)second/(86400 * 365)];
    }
}

- (NSString *)usualTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *time                   = [dateFormatter dateFromString:self];
    NSTimeInterval second          = [[NSDate date]timeIntervalSinceDate:time];
    
    if (second >= 0 && second <= 60) {
        return @"刚刚";
    }else if (second > 60 && second < 3600){
        return [NSString stringWithFormat:@"%d分钟前",(int)second/60];
    }else if (second >= 3600 && second < 86400){
        return [NSString stringWithFormat:@"%d小时前",(int)second/3600];
    }else if (second >= 86400 && second < 86400 * 2){
        return @"昨天";
    }else if (second >= 86400*2 && second < 86400 * 3){
        return @"前天";
    }else if (second >= 86400*3 && second < 86400 * 30){
        return [NSString stringWithFormat:@"%d天前",(int)second/86400];
    }else if (second >= 86400 *30 && second < 86400 * 365){
        return [NSString stringWithFormat:@"%d月前",(int)second/(86400 * 30)];
    }else{
        return [NSString stringWithFormat:@"%d年前",(int)second/(86400 * 365)];
    }
}

- (NSString *)chatTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *time                   = [dateFormatter dateFromString:self];
    NSTimeInterval second          = [[NSDate date]timeIntervalSinceDate:time];
    
    if (second >= 0 && second <= 60) {
        return @"刚刚";
    }else if (second > 60 && second < 3600){
        return [NSString stringWithFormat:@"%d分钟前",(int)second/60];
    }else if (second >= 3600 && second < 86400){
        return [NSString stringWithFormat:@"%d小时前",(int)second/3600];
    }else if (second >= 86400 && second < 86400 * 2){
        return @"昨天";
    }else if (second >= 86400*2 && second < 86400 * 3){
        return @"前天";
    }else if (second >= 86400*3 && second < 86400 * 30){
        return [NSString stringWithFormat:@"%d天前",(int)second/86400];
    }else if (second >= 86400 *30 && second < 86400 * 365){
        return [NSString stringWithFormat:@"%d月前",(int)second/(86400 * 30)];
    }else{
        return [NSString stringWithFormat:@"%d年前",(int)second/(86400 * 365)];
    }
}


- (NSTimeInterval)retuenTheSecondNowToTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *time                   = [dateFormatter dateFromString:self];
    NSTimeInterval second          = [[NSDate date]timeIntervalSinceDate:time];
    return second;

}

// 数字字符串转成带‘，’的金额字符串
- (NSString *)moneyString
{
    NSMutableString *resStr = [NSMutableString new];
    
    int index = (int)self.length;
    
    // 从字符串尾部查找小数部分
    NSRange range = [self rangeOfString:@"."];
    if (range.length != 0) {
        range.length = self.length - range.location;
        [resStr appendString: [self substringWithRange:range]];
        
        index = (int)range.location;
    }
    
    while (index>0) {
        
        if (index>3) {
            // 加逗号
            range.location = index-3;
            range.length = 3;
            [resStr insertString:[self substringWithRange:range] atIndex:0];
            [resStr insertString:@"," atIndex:0];
            
        }else{
            range.location = 0;
            range.length = index;
            [resStr insertString:[self substringWithRange:range] atIndex:0];
        }
        index -= 3;
    }
    
    return resStr;
}

- (float )stringFormaterToFloat:(NSString *)string
{
    float floatMoney = 0.;
    if (![string isEqualToString:@""] && ![string isEqual:[NSNull null]])
    {
        floatMoney = [[NSString stringWithFormat:@"%.2f",[[string stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue]] floatValue];
    }
    return floatMoney;
}

- (NSDate *)toDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date =  [formatter dateFromString:self];
    return date;
}


@end

@implementation NSString (TrimmingAdditions)

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (location; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (length; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

@end