//
//  UIView+Animation.h
//  FireShadow
//
//  Created by 翁志方 on 15/7/18.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, NZAnimationDirection){
    NZAnimationDirectionFromLeft,
    NZAnimationDirectionFromRight,
    NZAnimationDirectionFromTop,
    NZAnimationDirectionFromBottom
};


@interface UIView (Animation)

/**
 * 功能：从上下左右移动到原来位置
 */
- (void)moveWithDuration:(CGFloat) duration
              afterDelay:(CGFloat) delay
               direction:(NZAnimationDirection) direction
                  length:(CGFloat) length
                 stAlpha:(CGFloat) stAlpha
                 edAlpha:(CGFloat) edAlpha;

- (void)moveWithDuration:(CGFloat) duration
               direction:(NZAnimationDirection) direction
                  length:(CGFloat) length
                 stAlpha:(CGFloat) stAlpha
                 edAlpha:(CGFloat) edAlpha;

- (void)moveWithDuration:(CGFloat) duration
              afterDelay:(CGFloat) delay
               direction:(NZAnimationDirection) direction
                  length:(CGFloat) length;

- (void)moveWithDuration:(CGFloat) duration
               direction:(NZAnimationDirection) direction
                  length:(CGFloat) length;

- (void)moveFromBottomWithLenth:(CGFloat)len;

- (void)moveFromBottomWithLenth:(CGFloat)len afterDelay:(CGFloat) delay;



// 淡入
- (void)fadeInWithDuration:(CGFloat)duration afterDelay:(CGFloat)delay;

- (void)fadeInAfterDelay:(CGFloat) delay;

- (void)fadeInSecondAfterDelay:(CGFloat) delay;

// 第四页面震荡动画
- (void)shakeALitte;



// 扇形动画
- (void) sectorAnimationFromAngle:(CGFloat) stAngle
                          toAngle:(CGFloat) toAngle;

- (void) sectorAnimationFromAngle:(CGFloat) stAngle
                          toAngle:(CGFloat) toAngle
                     withDuration:(CGFloat) duration;





@end
