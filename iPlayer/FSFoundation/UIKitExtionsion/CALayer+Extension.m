//
//  CALayer+Extension.m
//  CashMaker
//
//  Created by 翁志方 on 16/3/30.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "CALayer+Extension.h"

@implementation CALayer (Extension)


- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}
- (UIColor *)borderColorFromUIColor
{
    return nil;
}


@end
