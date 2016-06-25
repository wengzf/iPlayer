//
//  UIView+ImageShot.m
//  FireShadow
//
//  Created by 翁志方 on 15/6/5.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#import "UIView+ImageShot.h"

@implementation UIView (ImageShot)

- (UIImage *)imageSnapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
