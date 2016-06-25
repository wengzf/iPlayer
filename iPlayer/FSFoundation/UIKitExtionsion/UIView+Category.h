//
//  UIView+Category.h
//  FireShadow
//
//  Created by liuhongmei on 15/5/19.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

/**
 *  生成一个frame = CGRectZero的 View，并设置translatesAutoresizingMaskIntoConstraints = NO
 *  backgroundcolor=[uicolor clear]
 *  @return view
 */
+ (instancetype)autolayoutView;


- (void)removeAllSublayer;      // 移除所有sublayer

- (void)removeAllSubView;       // 移除所有subviews

/**
 *  功能:显示loading
 */
- (void)showLoading;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second;

/**
 *  功能:隐藏loading
 */
- (void)hideLoading;

/**
 *  功能:隐藏loading
 */
- (void)hideLoadingOnView:(UIView *)aView;


/**
 *  功能:添加一个像素的分割线
 */
- (void)addTopOnePixelDevider;

/**
 *  功能:添加一个像素的分割线
 */
- (void)addBottomOnePixelDevider;

/**
 *  功能:该方法调用shouldResetDeviderLineToOnePixelInView 方法并 updateContraint
 */
- (void)resetDeviderLineToOnePixel;



/**
 *  功能:递归遍历所有subview，设置tag为911的分割线的 宽或高的约束为一个像素
 */
- (BOOL) shouldResetDeviderLineToOnePixel;


/**
 * 功能:晃动UIView动画
 */
- (void)shake;

- (void)showImageLoadingWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second;




@end
