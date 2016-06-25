//
//  UIView+Extension.m
//  WhiteSharkClient
//
//  Created by 翁志方 on 15/12/10.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "UIView+Extension.h"
#import "UILabel+Extension.h"

@implementation UIView (Extension)

- (CGFloat)originX
{
    return self.frame.origin.x;
}
- (CGFloat)originY
{
    return self.frame.origin.y;
}
- (CGFloat)endX
{
    return self.originX + self.width;
}
- (CGFloat)endY
{
    return self.originY + self.height;
}
- (CGFloat)width
{
    return self.bounds.size.width;
}
- (CGFloat)height
{
    return self.bounds.size.height;
}
- (CGPoint)centerOfCurrentView
{
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}
- (CGFloat)centerXOfCurrentView
{
    return self.bounds.size.width/2;
}
- (CGFloat)centerYOfCurrentView
{
    return self.bounds.size.height/2;
}

- (CGFloat)centerX
{
    return (self.frame.origin.x+self.bounds.size.width/2);
}
- (CGFloat)centerY
{
    return (self.frame.origin.y+self.bounds.size.height/2);
}

- (void)setOriginX:(CGFloat)originX
{
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}
- (void)setOriginY:(CGFloat)originY
{
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setCenterOfCurrentView:(CGPoint)centerOfCurrentView
{
    // readonly
}
- (void)setCenterX:(CGFloat)centerX
{
    CGRect frame = self.frame;
    frame.origin.x = centerX - self.width/2;
    self.frame = frame;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGRect frame = self.frame;
    frame.origin.y = centerY - self.height/2;
    self.frame = frame;
}
- (void)setEndX:(CGFloat)endX
{
    CGRect frame = self.frame;
    frame.origin.x = endX - self.width;
    self.frame = frame;
}
- (void)setEndY:(CGFloat)endY
{
    CGRect frame = self.frame;
    frame.origin.y = endY - self.height;
    self.frame = frame;
}

#pragma mark - 常用方法
- (void)setRoundCorner
{
    [self setRoundCornerWithColor:DeviderColor
                           radius:4
                            width:OnePixelWidth];
}
- (void)setRoundCornerWithColor:(UIColor *) color
                         radius:(CGFloat)radius
                          width:(CGFloat)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
}


#pragma mark - badge的计算
- (void)showBadgeNum:(NSString *)badgeStr
{
    NSMutableString *title = [NSMutableString stringWithString:@" "];
    [title appendString:badgeStr];
    [title appendString:@" "];
    
    // 寻找下面的badgeView
    UILabel *badge = (UILabel *)[self findBadgeLabelInView:self];
    if (badge == nil) {
        badge = [[UILabel alloc] initWithFont:HelveticaNeueLightFont(12) color:[UIColor whiteColor] title:title];
        badge.backgroundColor = [UIColor redColor];
        badge.tag = 900;
        
        badge.clipsToBounds = YES;
        badge.layer.cornerRadius = badge.height/2;
        
        [self addSubview:badge];
    }else{
        badge.text = title;
        [badge sizeToFit];
    }
    
    if ([badgeStr intValue] == 0) {
        badge.hidden = YES;
    }else{
        badge.hidden = NO;
    }
    
    badge.endX = self.width;
    badge.originY = 0;

}

- (UIView *)findBadgeLabelInView:(UIView *)view
{
    for (UIView *sub in view.subviews) {
        if (sub.tag == 900) {
            return sub;
        }else{
            UIView *res = [self findBadgeLabelInView:sub];
            if (res) {
                return res;
            }
        }
    }
    return nil;
}





@end
