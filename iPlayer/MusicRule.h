//
//  MusicRule.h
//  iPlayer
//
//  Created by 翁志方 on 15/12/5.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicRule : NSObject

// 调性
@property (nonatomic, assign) int pitchSymbol;               // 0=正常  1=降调  2=升调
@property (nonatomic, assign) int pitchName;                 // 1=C  2=D ...

// 拍号
@property (nonatomic, assign) int beatPerSection;            // 以X拍为一小节
@property (nonatomic, assign) int notePerBeat;               // 以X分音符为一拍

// 速度
@property (nonatomic, assign) int beatPerMinute;            // 默认行板速度       #=72

// 基本单位     以64分之一为基本单位
@property (nonatomic, assign) int baseUnitNum;              // 默认为16分音符作为基本单位
@property (nonatomic, assign) double baseUnitTime;             // 单位秒




- (void) calculateBaseUnitTime;

@end
