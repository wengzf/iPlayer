//
//  UIView+Animation.m
//  FireShadow
//
//  Created by 翁志方 on 15/7/18.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#import "UIView+Animation.h"


#define DEFAULT_SECTOR_ANIMATION_DURATION 2.0

static CAShapeLayer *shapeLayer;

static CGFloat radius;

static CGFloat startAngle;
static CGFloat curAngle;
static CGFloat angleDelta;

static CGFloat animationDuration;
static CGFloat curAnimationTime;

static NSTimer *sectorAnimationTimer;


@implementation UIView (Animation)


/**
 * 功能：从上下左右移动到原来位置
 */
- (void)moveWithDuration:(CGFloat) duration
              afterDelay:(CGFloat) delay
               direction:(NZAnimationDirection) direction
                  length:(CGFloat) length
                 stAlpha:(CGFloat) stAlpha
                 edAlpha:(CGFloat) edAlpha
{
    CGRect originFrame = self.frame;
    
    CGRect frame = originFrame;
    switch (direction) {
        case NZAnimationDirectionFromLeft:
            frame.origin.x -= length;
            break;
            
        case NZAnimationDirectionFromRight:
            frame.origin.x += length;
            break;
            
        case NZAnimationDirectionFromTop:
            frame.origin.y -= length;
            break;
            
        case NZAnimationDirectionFromBottom:
            frame.origin.y += length;
            break;
            
        default:
            break;
    }
    self.frame = frame;
    
    self.alpha = stAlpha;
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.frame = originFrame;
                         self.alpha = edAlpha;
                         
                     } completion:NULL];
}

- (void)moveWithDuration:(CGFloat) duration
               direction:(NZAnimationDirection) direction
                  length:(CGFloat) length
                 stAlpha:(CGFloat) stAlpha
                 edAlpha:(CGFloat) edAlpha
{
    [self moveWithDuration:duration
                afterDelay:0
                 direction:direction
                    length:length
                   stAlpha:stAlpha
                   edAlpha:edAlpha];
}

- (void)moveWithDuration:(CGFloat) duration
              afterDelay:(CGFloat) delay
               direction:(NZAnimationDirection) direction
                  length:(CGFloat) length
{
    CGFloat alpha = self.alpha;
    [self moveWithDuration:duration
                afterDelay:delay
                 direction:direction
                    length:length
                   stAlpha:alpha
                   edAlpha:alpha];
}

- (void)moveWithDuration:(CGFloat) duration
               direction:(NZAnimationDirection) direction
                  length:(CGFloat) length
{
    [self moveWithDuration:duration afterDelay:0 direction:direction length:length];
}

- (void)moveFromBottomWithLenth:(CGFloat)len
{
    [self moveWithDuration:0.3 direction:NZAnimationDirectionFromBottom length:len stAlpha:0.3 edAlpha:1.0];
}
- (void)moveFromBottomWithLenth:(CGFloat)len afterDelay:(CGFloat) delay
{
    CGFloat duration = 0.3;
    
    CGFloat stAlpha = 0;
    CGFloat edAlpha = 1.0;
    
    [self moveWithDuration:duration afterDelay:delay direction:NZAnimationDirectionFromBottom length:len stAlpha:stAlpha edAlpha:edAlpha];
}


- (void)fadeInWithDuration:(CGFloat)duration afterDelay:(CGFloat)delay
{
    self.alpha = 0;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}
- (void)fadeInAfterDelay:(CGFloat) delay
{
    const CGFloat duration = 1.0;
    
    self.alpha = 0;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];

}

- (void)fadeInSecondAfterDelay:(CGFloat) delay
{
    const CGFloat duration = 1.8;
    
    self.alpha = 0;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}


//

- (void)shakeALitte
{

    CGRect originFrame = self.frame;
    __block CGRect frame;
    
    CGFloat duration = 0.1;
    __block CGFloat vibration = originFrame.size.width / 6;
    CGFloat delta = vibration / 5;
    
    [UIView animateWithDuration:duration animations:^{
        vibration -= delta;
        frame = originFrame;
        frame.origin.x -= vibration;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            vibration -= delta;
            frame = originFrame;
            frame.origin.x += vibration;
            self.frame = frame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration animations:^{
                vibration -= delta;
                frame = originFrame;
                frame.origin.x -= vibration;
                self.frame = frame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration animations:^{
                    vibration -= delta;
                    frame = originFrame;
                    frame.origin.x += vibration;
                    self.frame = frame;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:duration animations:^{
                        
                        self.frame = originFrame;
                        
                    } completion:^(BOOL finished) {

                    }];
                }];
            }];
        }];
    }];
}





- (void) sectorAnimationFromAngle:(CGFloat) stAngle
                          toAngle:(CGFloat) toAngle
{
    [self sectorAnimationFromAngle:stAngle
                           toAngle:toAngle
                      withDuration:DEFAULT_SECTOR_ANIMATION_DURATION];
}

- (void) sectorAnimationFromAngle:(CGFloat) stAngle
                          toAngle:(CGFloat) toAngle
                     withDuration:(CGFloat) duration
{
    
    shapeLayer = [CAShapeLayer layer];
    
    startAngle = stAngle;
    curAngle = stAngle;
    
    curAnimationTime = 0;
    animationDuration = duration;
    
    // 保证duration！=0
    if (fabs(duration) > 0.00001 ){
        angleDelta = (toAngle - stAngle) / duration / 60;
    }else{
        angleDelta = toAngle - stAngle;
    }
    
    // 启动定时器
    if (sectorAnimationTimer) {
        [sectorAnimationTimer invalidate];
    }
    sectorAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:1/60.0
                                                            target:self
                                                          selector:@selector(sectorAnimationTimerAction)
                                                          userInfo:nil
                                                           repeats:YES];
    [sectorAnimationTimer fire];
}

- (void)sectorAnimationTimerAction
{
    curAngle += angleDelta;
    
    // 绘制扇形maskShape
    CGFloat wid = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat centerX = wid/2.0;
    CGFloat centerY = height/2.0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    radius = wid/2;
    CGPathMoveToPoint(path, NULL, centerX, centerY);
    
    
    CGPathAddArc(path, NULL, centerX, centerY , wid+height, M_PI_2, curAngle, NO);
    
    CGPathAddLineToPoint(path, NULL, centerX, centerY);
    
    shapeLayer.path = path;
    
    self.layer.mask = shapeLayer;
    
    // 终止时间判断
    curAnimationTime += 1/60.0;
    if (curAnimationTime > animationDuration) {
        [sectorAnimationTimer invalidate];
        sectorAnimationTimer = nil;
    }
}


@end
