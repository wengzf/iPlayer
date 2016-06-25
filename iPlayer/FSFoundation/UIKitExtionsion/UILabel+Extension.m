//
//  UILabel+Extension.m
//  WhiteSharkBusiness
//
//  Created by 翁志方 on 15/12/30.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (UILabel *)initWithFont:(UIFont *) font color:(UIColor *)color
{
    self = [super init];
    
    self.font = font;
    self.textColor = color;
    
    return self;
}
- (UILabel *)initWithFont:(UIFont *) font color:(UIColor *)color title:(NSString *)title
{
    self = [super init];
    
    self.font = font;
    self.textColor = color;
    self.text = title;
    [self sizeToFit];
    
    return self;

}

@end
