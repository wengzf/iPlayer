//
//  UIImage+ResizeAndColor.m
//  gannicus
//
//  Created by Zhu Boxing on 13-12-13.
//  Copyright (c) 2013年 bbk. All rights reserved.
//

#import "UIImage+ResizeAndColor.h"

@implementation UIImage (ResizeAndColor)
//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    
    return smallImage;
}

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height * 1.0 / height;
    float horizontalRadio = size.width * 1.0 / width;
    
    float radio = 1;
    if(verticalRadio > 1 && horizontalRadio > 1) {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    } else {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width * radio;
    height = height * radio;
    
    int xPos = (size.width - width) / 2;
    int yPos = (size.height - height) / 2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)corpScaleToSize:(CGSize)size
{
    CGImageRef sourceImageRef = self.CGImage;
    CGFloat width = CGImageGetWidth(sourceImageRef);
    CGFloat height = CGImageGetHeight(sourceImageRef);
    
    CGSize selfsize = (CGSize) {width, height};
    CGRect rect = [self imageRect:selfsize toSize:size];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    [newImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(newImageRef);
    
    return scaleImage;
}

- (CGRect)imageRect:(CGSize)imageSize toSize:(CGSize)tsize
{
    BOOL isScaleW = imageSize.width / tsize.width < imageSize.height / tsize.height;
    CGRect iRect;
    if (isScaleW) {
        iRect = CGRectMake(0, (imageSize.height - imageSize.width * tsize.height / tsize.width) / 2, imageSize.width, imageSize.width * tsize.height / tsize.width);
    } else {
        iRect = CGRectMake((imageSize.width - imageSize.height * tsize.width / tsize.height) / 2, 0, imageSize.height * tsize.width / tsize.height, imageSize.height);
    }
    return iRect;
}

- (UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, 1);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:grayImageRef];
    CGContextRelease(context);
    CGImageRelease(grayImageRef);
    
    return grayImage;
}
@end