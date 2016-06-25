//
//  UIButton+Extension.h
//  WhiteSharkBusiness
//
//  Created by 翁志方 on 15/12/31.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)


// 实例化方法
- (UIButton *)initWithFont:(UIFont *) font
                     color:(UIColor *)color;

- (UIButton *)initWithFont:(UIFont *) font
                     color:(UIColor *)color
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
              cornerRadius:(CGFloat)cornerRadius;

- (UIButton *)initWithFont:(UIFont *) font
                     color:(UIColor *)color
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
              cornerRadius:(CGFloat)cornerRadius
           backgroundColor:(UIColor *)backgroundColor;


// 属性设置
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) NSString *imageName;

// 实用方法
- (void)addTarget:(id)target action:(SEL)sel;


//
//- (void)setTitle:(NSString *)title;
//- (void)setTitleColor:(UIColor *)color;

@end
