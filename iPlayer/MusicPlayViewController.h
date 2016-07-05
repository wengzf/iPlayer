//
//  MusicPlayViewController.h
//  iPlayer
//
//  Created by 翁志方 on 15/12/5.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicNoteButton;
@protocol MusicNoteButtonDelegate <NSObject>

- (void)musicNoteButtonClked:(MusicNoteButton *)btn;

@end


@interface MusicNoteButton : UIButton
{
    AVAudioPlayer *pitchPlayer;
}

@property (nonatomic, strong) id<MusicNoteButtonDelegate> delegate;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) int pos;          // 所在的轨道，随机分配

@property (nonatomic, strong) MusicNote *note;  // 音符

@property (nonatomic, strong) NSMutableArray *pitchFileNameArr;

@property (nonatomic, assign) int basePitchOffset;



- (void)btnClked;

//@property (strong, nonatomic) void(^updateLightStick)(NSInteger pos, CGFloat top);


@end



@interface MusicPlayViewController : UIViewController<MusicNoteButtonDelegate>

@property (nonatomic, strong) MusicRule *musicRule;
@property (nonatomic, strong) NSMutableArray *musicNoteArr;

@property (nonatomic, strong) NSMutableArray *pitchFileNameArr;

@property (nonatomic, assign) int basePitchOffset;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)backBtnClked:(id)sender;

@end


/*
    喷射音符，像水一样
 
 
    从屏幕最上方开始向下移动对应的方块，直到底下，消失的速度和每个音符的时间一样
    音符出现在4条线，随机
    排列成一条线速度定为 200 pt/s
 
 
 
*/