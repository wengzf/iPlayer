//
//  STScratchView.h
//  STScratchView
//
//  Created by Sebastien Thiebaud on 12/17/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef void(^ScratchCompletion)();

@interface STScratchView : UIView
{
    CGPoint previousTouchLocation;
    CGPoint currentTouchLocation;
    
    CGImageRef hideImage;
    CGImageRef scratchImage;

	CGContextRef contextMask;
    
    NSMutableArray *pointArr;
}

@property (nonatomic, assign) float percentAccomplishment;
@property (nonatomic, assign) float sizeBrush;

@property (nonatomic, strong) UIView *hideView;
/**
 涂层是否已被刮开
 */
@property (nonatomic, assign, readonly, getter = isOpen) BOOL open;

/**
 刮出后的回调.
 */
@property (nonatomic, strong) ScratchCompletion completion;

- (void)setHideView:(UIView *)hideView;

@end
