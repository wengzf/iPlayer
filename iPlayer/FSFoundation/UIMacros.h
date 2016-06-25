//
//  UIMacros.h
//  WhiteSharkClient
//
//  Created by 翁志方 on 15/12/11.
//  Copyright © 2015年 wzf. All rights reserved.
//

#ifndef UIMacros_h
#define UIMacros_h


// 位置
#define WIDTH  self.view.frame.size.width
#define HEIGHT  self.view.frame.size.height

#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width


// 颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGB(r,g,b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define UIColorWithHex(x) RGB(((x)&0xFF0000) >> 16, ((x)&0xFF00) >> 8 ,  ((x)&0xFF))
#define GRAY(x) RGB((x),(x),(x))
#define DeviderColor GRAY(224)

#define RandomColor UIColorWithHex(arc4random()%0xFFFFFF)


#define UIColor33 UIColorWithHex(0x333333)
#define UIColor66 UIColorWithHex(0x666666)
#define UIColor99 UIColorWithHex(0x999999)
#define UIColorCC UIColorWithHex(0xcccccc)

#define mainColor UIColorWithHex(0xff8811)

#define mainTextColor
#define mainBtnColor UIColorWithHex(0xf98435)


#define navigationBarColor    RGB(35,39,54)
#define mainBackgroundColor   RGB(35,39,54)
#define translucentStyleColor RGBA(250,58,17,0.5)

#define OnePixelWidth  (ScreenWidth == 414 ? 0.334 : 0.5)

#define marginX (ScreenWidth == 414 ? 16 : 10)
#define marginY (ScreenWidth == 414 ? 16 : 10)


// 字体
#define HelveticaNeueFont(fontSize)  [UIFont fontWithName:@"HelveticaNeue" size:(fontSize)]
#define HelveticaNeueLightFont(fontSize)    [UIFont fontWithName:@"HelveticaNeue-Light" size:(fontSize)]




#endif /* UIMacros_h */
