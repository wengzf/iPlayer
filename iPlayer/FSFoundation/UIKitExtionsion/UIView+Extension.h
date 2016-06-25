//
//  UIView+Extension.h
//  WhiteSharkClient
//
//  Created by 翁志方 on 15/12/10.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)


@property (nonatomic, assign) CGFloat originX;

@property (nonatomic, assign) CGFloat originY;

@property (nonatomic, assign) CGFloat endX;

@property (nonatomic, assign) CGFloat endY;


@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign, readonly) CGPoint centerOfCurrentView;

@property (nonatomic, assign) CGFloat centerXOfCurrentView;

@property (nonatomic, assign) CGFloat centerYOfCurrentView;


@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;


// 设置圆角
- (void)setRoundCorner;
- (void)setRoundCornerWithColor:(UIColor *) color
                         radius:(CGFloat)radius
                          width:(CGFloat)width;


// 设置badge
- (void)showBadgeNum:(NSString *)badgeStr;


@end
