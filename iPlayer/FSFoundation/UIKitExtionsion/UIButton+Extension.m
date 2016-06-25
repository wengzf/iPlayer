//
//  UIButton+Extension.m
//  WhiteSharkBusiness
//
//  Created by 翁志方 on 15/12/31.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)




- (UIButton *)initWithFont:(UIFont *) font
                     color:(UIColor *)color
{
    return [self initWithFont:font
                        color:color
                  borderColor:[UIColor clearColor]
                  borderWidth:0
                cornerRadius:0];
}

- (UIButton *)initWithFont:(UIFont *) font
                     color:(UIColor *)color
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
              cornerRadius:(CGFloat)cornerRadius
{
    return [self initWithFont:font
                        color:color
                  borderColor:borderColor
                  borderWidth:borderWidth
                 cornerRadius:cornerRadius
              backgroundColor:[UIColor whiteColor]];
}

- (UIButton *)initWithFont:(UIFont *) font
                     color:(UIColor *)color
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
              cornerRadius:(CGFloat)cornerRadius
           backgroundColor:(UIColor *)backgroundColor
{
    self = [super init];
    
    self.titleLabel.font = font;
    
    [self setTitleColor:color forState:UIControlStateNormal];
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = cornerRadius;
    self.backgroundColor = backgroundColor;
    
    return self;
}


- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}
- (void)setImageName:(NSString *)imageName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)sel
{
    [self addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

@end
