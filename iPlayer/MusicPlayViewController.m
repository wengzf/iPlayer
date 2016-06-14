//
//  MusicPlayViewController.m
//  iPlayer
//
//  Created by 翁志方 on 15/12/5.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "MusicPlayViewController.h"


@implementation MusicNoteButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(btnClked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)btnClked
{
    // 播放音高文件名解析
    NSString *pitchFileName = [self parsePitch:self.note];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:pitchFileName ofType:@"wav"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSError *err;
    pitchPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&err];
    [pitchPlayer prepareToPlay];
    [pitchPlayer play];
}
- (NSString *) parsePitch:(MusicNote *) note
{
    // 确定音符偏移  72 c4    sabc  s符号位    a升降号   b所在音层级    c唱名
    int arrPitch[] = {0, 0, 2, 4, 5, 7, 9, 11};
    int pitchOffset = self.basePitchOffset;
    
    if (note.pitchSymbol==1){        // 降调
        --pitchOffset;
    }else if (note.pitchSymbol==2){  // 升调
        ++pitchOffset;
    }
    
    pitchOffset += 12*note.pitchLevel;
    
    pitchOffset += arrPitch[note.pitchName];
    
    //  1. 根据调性确定 dou的基本号数位置
    //  2. 计算音符相对 dou的基本偏移     可以在初始化的时候就计算出来
    
    NSString *pitchFileName = self.pitchFileNameArr[pitchOffset];
    
    return pitchFileName;
}

@end



@interface MusicPlayViewController ()
{
    double curTime;         // 当前时间
    double timeSpan;
    double edTime;
    
    double timerDuration;   // 定时间周期
    NSTimer *playerTimer;
    
    double btnHeight;
    double speed;           // 进行速度
  
    NSMutableArray *reuseButtonArr;         // MusicNoteButton
    NSMutableArray *curRunningArr;          // MusicNoteButton
}

@end

@implementation MusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    btnHeight = 120;
    speed = (btnHeight+30) / self.musicRule.baseUnitTime / 2;
    
    // 重用机制数组
    {
        reuseButtonArr = [NSMutableArray array];
        curRunningArr = [NSMutableArray array];
    }
    
    // 定时器
    {
        timerDuration = 1/60.0;
        playerTimer = [NSTimer scheduledTimerWithTimeInterval:timerDuration target:self selector:@selector(playerTimerAction) userInfo:nil repeats:YES];
    }

    // 添加横线
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 320, 220)];
//    label.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
//    [self.view addSubview:label];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [playerTimer invalidate];
    playerTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MusicNoteButton *)reuseButton
{
    MusicNoteButton *resButton;
    if ([reuseButtonArr count]) {
        resButton = [reuseButtonArr lastObject];
        [reuseButtonArr removeLastObject];
    }else{
        resButton = [[MusicNoteButton alloc] initWithFrame:CGRectMake(0, 0, 80, btnHeight)];
        resButton.pitchFileNameArr = self.pitchFileNameArr;
        resButton.basePitchOffset = self.basePitchOffset;
        resButton.backgroundColor = [UIColor orangeColor];
    }
    resButton.alpha = 1.0;
    [self.view addSubview:resButton];
    return resButton;
}

#pragma mark - 定时器

- (BOOL) equal:(double) a to:(double) b
{
    return fabs(a-b) <= timerDuration;
}

- (void)playerTimerAction
{
    // 退出
    {
        MusicNoteButton *btn = [curRunningArr firstObject];
        if (btn.frame.origin.y > 450) {
            
//            [btn btnClked];
            
            [reuseButtonArr  addObject:btn];
            [btn removeFromSuperview];
            [curRunningArr removeObjectAtIndex:0];
            
        }
    }
    
    // 新进入
    {
        MusicNote *note = [self.musicNoteArr firstObject];
        
        printf("%f %f\n",curTime,note.showTime);
        
        if (note && note.showTime <= curTime) {             // 数组不为空
            MusicNoteButton *button = [self reuseButton];
            if (button == nil) {
                printf("%f %f\n",curTime,note.showTime);
            }
            button.note = note;
            button.pos = arc4random() % 4;
            
            [curRunningArr addObject:button];
            [self.musicNoteArr removeObjectAtIndex:0];
        }
    }
    
    // 检查结束
    if (self.musicNoteArr.count == 0 && curRunningArr.count==0) {
        [playerTimer invalidate];
        return ;
    }
    
    // 根据当前时间绘制页面
    {
        int screenWid = self.view.bounds.size.width;
        
        for (MusicNoteButton *btn in curRunningArr) {
            int posx = screenWid/4*btn.pos;
            int posy = (curTime - btn.note.showTime) * speed;
            
            printf("%d %d\n",posx, posy);
            
            CGRect frame = btn.frame;
            frame.origin.x = posx;
            frame.origin.y = posy;
            btn.frame = frame;
            
            if (btn.frame.origin.y>280) {
                btn.alpha = 1 - (btn.frame.origin.y -280) /120;
            }
        }
    }
    
    curTime += timerDuration;
}


- (IBAction)backBtnClked:(id)sender {
    
    // 
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
