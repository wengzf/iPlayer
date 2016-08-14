//
//  LMSUpdateCommentView.m
//  FireShadow
//
//  Created by 翁志方 on 15/9/26.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#import "LMSUpdateCommentView.h"

@implementation LMSUpdateCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [[NSBundle mainBundle] loadNibNamed:@"LMSUpdateCommentView" owner:nil options:nil][0];
    self.frame = frame;
    
    // 分割线设置为一个像素
    {
        [self resetDeviderLineToOnePixel];
    }
    return self;
}

- (void)showWithSting:(NSString *) contentStr canExit:(BOOL) canExit
{
    self.contentLabel.text = contentStr;
    
    if (canExit){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBtnClked)];
        [self addGestureRecognizer:tap];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self performSelector:@selector(showAnimation) withObject:nil afterDelay:0];
}

- (void)showAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.97, 0.97);
        self.contentView.transform = transform;
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGAffineTransform transform = CGAffineTransformMakeScale(1.02, 1.02);
            self.contentView.transform = transform;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.08 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                CGAffineTransform transform = CGAffineTransformMakeScale(0.99, 0.99);
                self.contentView.transform = transform;
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.06 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    self.contentView.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {

                }];
            }];
        }];
    });
}

- (void)closeBtnClked
{
    [self removeFromSuperview];
}

- (IBAction)jumpToUpdate
{
    
    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/yin-le-lian-xi/id1133055028?mt=8"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

@end
