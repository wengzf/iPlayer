//
//  MusicNote.h
//  iPlayer
//
//  Created by 翁志方 on 15/12/5.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MusicNote : NSObject


// 调性
@property (nonatomic, assign) int pitchSymbol;              // 0=正常  1=降调  2=升调

@property (nonatomic, assign) int pitchLevel;                // 默认为中音 5
@property (nonatomic, assign) int pitchName;                 // 1=C  2=D ...


// 时值
@property (nonatomic, assign) int duration;                            // 直接保存从文件中读出来的

// 计算出来的实际时间，以秒做单位
@property (nonatomic, assign) double realDuration;

// 播放时间
@property (nonatomic, assign) double showTime;  


@end
