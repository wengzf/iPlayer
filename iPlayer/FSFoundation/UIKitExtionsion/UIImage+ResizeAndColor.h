//
//  UIImage+ResizeAndColor.h
//  gannicus
//
//  Created by Zhu Boxing on 13-12-13.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeAndColor)
- (UIImage*)getSubImage:(CGRect)rect;
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage*)getGrayImage:(UIImage*)sourceImage;
- (UIImage *)corpScaleToSize:(CGSize)size;
@end
