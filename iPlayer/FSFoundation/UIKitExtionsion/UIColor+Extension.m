//
//  UIColor+Extension.m
//  FireShadow
//
//  Created by 翁志方 on 15/8/5.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)


+ (UIColor *)colorWithHex:(NSString*)hexStr
{
    // 不做参数合法性验证
    float r,g,b;
    float x,y;
    
    x = [self valueWithHexChar:[hexStr characterAtIndex:0]];
    y = [self valueWithHexChar:[hexStr characterAtIndex:1]];
    r = x*16+y;
    
    x = [self valueWithHexChar:[hexStr characterAtIndex:2]];
    y = [self valueWithHexChar:[hexStr characterAtIndex:3]];
    g = x*16+y;
    
    x = [self valueWithHexChar:[hexStr characterAtIndex:4]];
    y = [self valueWithHexChar:[hexStr characterAtIndex:5]];
    b = x*16+y;
    
    return RGB(r, g, b);
}
+ (int)valueWithHexChar:(unichar) ch
{
    if ('0'<=ch && ch<='9') {
        return ch-'0';
    }
    if ('A'<=ch && ch<='Z') {
        return ch-'A'+10;
    }
    if ('a'<=ch && ch<='z') {
        return ch-'a'+10;
    }
    return 0;
}

@end
