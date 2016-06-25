//
//  STScratchView.m
//  STScratchView
//
//  Created by Sebastien Thiebaud on 12/17/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import "STScratchView.h"


@interface STScratchView()

@property (nonatomic, assign, getter = isOpen) BOOL open;

@end


@implementation STScratchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        
        _sizeBrush = 30.0;
    }
    return self;
}

#pragma mark -
#pragma mark CoreGraphics methods

// Will be called every touch and at the first init
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIImage *imageToDraw = [UIImage imageWithCGImage:scratchImage];
    [imageToDraw drawInRect:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
}

// Method to change the view which will be scratched
- (void)setHideView:(UIView *)hideView
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
	long bitmapByteCount;
	long bitmapBytesPerRow;

    float scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(hideView.bounds.size, NO, 0);
    [hideView.layer renderInContext:UIGraphicsGetCurrentContext()];
    hideView.layer.contentsScale = scale;
    hideImage = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
    
    size_t imageWidth = CGImageGetWidth(hideImage);
    size_t imageHeight = CGImageGetHeight(hideImage);
        
	bitmapBytesPerRow = (imageWidth * 4);
	bitmapByteCount = (bitmapBytesPerRow * imageHeight);
    
    printf("%ld %ld",bitmapBytesPerRow, bitmapByteCount);
    
    CFMutableDataRef pixels = CFDataCreateMutable(NULL, imageWidth * imageHeight);
    contextMask = CGBitmapContextCreate(CFDataGetMutableBytePtr(pixels), imageWidth, imageHeight , 8, imageWidth, colorspace, kCGImageAlphaNone);
    
    if (contextMask == NULL)
    {
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"刮刮卡" message:@"确定花费10coins来抽奖" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alv show];
    }
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(pixels);
    
    CGContextSetFillColorWithColor(contextMask, [UIColor blackColor].CGColor);
    CGContextFillRect(contextMask, self.frame);
    
    CGContextSetStrokeColorWithColor(contextMask, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(contextMask, _sizeBrush);
    CGContextSetLineCap(contextMask, kCGLineCapRound);
    
    CGImageRef mask = CGImageMaskCreate(imageWidth, imageHeight, 8, 8, imageWidth, dataProvider, nil, NO);
    scratchImage = CGImageCreateWithMask(hideImage, mask);
    
    CGImageRelease(mask);
    CGColorSpaceRelease(colorspace);
}

- (void)scratchTheViewFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    float scale = [UIScreen mainScreen].scale;

    CGContextMoveToPoint(contextMask, startPoint.x * scale, (self.frame.size.height - startPoint.y) * scale);
	CGContextAddLineToPoint(contextMask, endPoint.x * scale, (self.frame.size.height - endPoint.y) * scale);
	CGContextStrokePath(contextMask);
	[self setNeedsDisplay];
    
}

#pragma mark -
#pragma mark Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[event touchesForView:self] anyObject];
    currentTouchLocation = [touch locationInView:self];
 
    if (pointArr==nil) {
        
        pointArr = [NSMutableArray array];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [[event touchesForView:self] anyObject];
   
    if (!CGPointEqualToPoint(previousTouchLocation, CGPointZero))
    {
        currentTouchLocation = [touch locationInView:self];
        
        [pointArr addObject:[NSValue valueWithCGPoint: currentTouchLocation]];
    }
    
    previousTouchLocation = [touch previousLocationInView:self];
   
    [self scratchTheViewFrom:previousTouchLocation to:currentTouchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [[event touchesForView:self] anyObject];

    if (!CGPointEqualToPoint(previousTouchLocation, CGPointZero))
    {
        previousTouchLocation = [touch previousLocationInView:self];
        [self scratchTheViewFrom:previousTouchLocation to:currentTouchLocation];
    }
    
    [self checkForOpen];
}

- (void)checkForOpen
{
    CGSize size = self.bounds.size;
    
    CGFloat left, right, up, down;
    left = size.width * 0.25;
    right = size.width * 0.75;
    up = size.height * 0.25;
    down = size.height * 0.75;
    
    BOOL leftFlag = NO, rightFlag = NO, upFlag = NO, downFlag = NO;

    for (NSValue *val in pointArr) {
        CGPoint pos = [val CGPointValue];
        if (pos.x < left) {
            leftFlag = YES;
        }
        if (pos.x > right) {
            rightFlag = YES;
        }
        if (pos.y < up) {
            upFlag = YES;
        }
        if (pos.y < down) {
            downFlag = YES;
        }
    }
    
    if (leftFlag && rightFlag && upFlag && downFlag && !self.open) {
        self.open = YES;
        if (self.completion) {
            self.completion();
        }
    }

}- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)initScratch
{
    currentTouchLocation = CGPointZero;
    previousTouchLocation = CGPointZero;
}


- (UIImage *)imageByColor:(UIColor *)color
{
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
