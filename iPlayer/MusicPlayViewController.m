//
//  MusicPlayViewController.m
//  iPlayer
//
//  Created by 翁志方 on 15/12/5.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "MusicPlayViewController.h"


#define WIDTH  self.view.frame.size.width
#define HEIGHT  self.view.frame.size.height

#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGB(r,g,b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define UIColorWithHex(x) RGB(((x)&0xFF0000) >> 16, ((x)&0xFF00) >> 8 ,  ((x)&0xFF))




static BOOL flagPlayMode = NO;


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
    if (flagPlayMode) {
        NSString *pitchFileName = [self parsePitch:self.note];
        
        NSString * filePath = [[NSBundle mainBundle] pathForResource:pitchFileName ofType:@"mp3"];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        NSError *err;
        pitchPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&err];
        [pitchPlayer prepareToPlay];
        [pitchPlayer play];
    }
    // 刷新对应页面
    [self.delegate musicNoteButtonClked:self];
}
- (void)play
{
    // 播放音高文件名解析
    NSString *pitchFileName = [self parsePitch:self.note];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:pitchFileName ofType:@"mp3"];
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
    
    NSMutableArray *lightImageArr;
    
    
    BOOL isStart;
}

@end

@implementation MusicPlayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnHeight = 120;
    speed = (btnHeight+10) / self.musicRule.baseUnitTime;
    
    // 我扣得搞一两个小时
    // 重用机制数组
    {
        reuseButtonArr = [NSMutableArray array];
        curRunningArr = [NSMutableArray array];
    }
    
    // 定时器
    {
        timerDuration = 1/60.0;
        
        while (!isStart) {
            [self playerTimerAction];
        }
        
    }

    // 添加横线
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight-btnHeight, ScreenWidth, 3)];
    label.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [self.view addSubview:label];
    
    // 添加4条点击后的发光柱
    lightImageArr = [NSMutableArray array];
    
    CGFloat x = 0;
    for (int i=0; i<4; ++i) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, ScreenWidth/4.0, ScreenHeight-btnHeight)];
        [lightImageArr addObject:imgView];
        imgView.alpha = 0;
        imgView.image = [UIImage imageNamed:@"error stick"];
        [self.view addSubview:imgView];
        x+=ScreenWidth/4;
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    if (flagPlayMode) {
        [self.plsyModeBtn setTitle:@"游戏模式"];
    }else{
        [self.plsyModeBtn setTitle:@"播放模式"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (playerTimer){
        [playerTimer invalidate];
        playerTimer = nil;
    }
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
        @synchronized (self) {
            [reuseButtonArr removeLastObject];
        }
        if (resButton.isFirst) {
            resButton = [[MusicNoteButton alloc] initWithFrame:CGRectMake(0, 0, 80, btnHeight)];
            resButton.delegate = self;
            resButton.pitchFileNameArr = self.pitchFileNameArr;
            resButton.basePitchOffset = self.basePitchOffset;
            resButton.backgroundColor = [UIColor whiteColor];
        }
    }else{
        resButton = [[MusicNoteButton alloc] initWithFrame:CGRectMake(0, 0, 80, btnHeight)];
        resButton.delegate = self;
        resButton.pitchFileNameArr = self.pitchFileNameArr;
        resButton.basePitchOffset = self.basePitchOffset;
        resButton.backgroundColor = [UIColor whiteColor];
        
    }
    resButton.alpha = 1.0;
    [self.view addSubview:resButton];
    return resButton;
}

- (void)musicNoteButtonClked:(MusicNoteButton *)btn
{
    if (playerTimer == nil) {
        if (btn.isFirst) {
            playerTimer = [NSTimer scheduledTimerWithTimeInterval:timerDuration target:self selector:@selector(playerTimerAction) userInfo:nil repeats:YES];
        }
    }else{
        
        int pos = btn.pos;
        CGFloat top = btn.frame.origin.y;
        // 显示光柱
        UIImageView *imgview = lightImageArr[pos];
        if ((top>ScreenHeight-btnHeight-btnHeight-10) && (top<ScreenHeight-btnHeight/2) ){
            imgview.image = [UIImage imageNamed:@"right stick"];
        }else{
            imgview.image = [UIImage imageNamed:@"error stick"];
        }
        imgview.alpha = 0.7;
        [UIView animateWithDuration:2 animations:^{
            imgview.alpha = 0;
        }];
    }
}

#pragma mark - 定时器

- (BOOL) equal:(double) a to:(double) b
{
    return fabs(a-b) <= timerDuration;
}

- (void)playerTimerAction
{
    // 退出
    
    MusicNoteButton *btn = [curRunningArr firstObject];
    if (!isStart) {
        
        if (btn.frame.origin.y > ScreenHeight-btnHeight-btnHeight-6) {
            isStart = YES;
            
            btn.isFirst = YES;
            // 添加开始三角形
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            CGFloat wid = btn.frame.size.width / 2;
            CGFloat height = btn.frame.size.height / 2;
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, wid - 15, height - 23);
            CGPathAddLineToPoint(path, nil, wid+18, height);
            CGPathAddLineToPoint(path, nil, wid-15, height+23);
            CGPathAddLineToPoint(path, nil, wid-15, height - 23);
            shapeLayer.fillColor = [UIColor blackColor].CGColor;
            shapeLayer.path = path;
            [btn.layer addSublayer:shapeLayer];
            
            return;
        }
    }
    
    if (btn.frame.origin.y > ScreenHeight-btnHeight/2.0) {
        
        if (!flagPlayMode){
            [btn play];
        }
        // button从正在运行数组中删除
        @synchronized (self) {
            [reuseButtonArr addObject:btn];
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

            button.note = note;
            button.pos = arc4random() % 4;
            
            [curRunningArr addObject:button];
            [self.musicNoteArr removeObjectAtIndex:0];
        }
    }
    
    // 检查结束
    if (self.musicNoteArr.count == 0 && curRunningArr.count==0) {
        [playerTimer invalidate];
        playerTimer = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return ;
    }
    
    // 根据当前时间绘制页面
    {
        int screenWid = self.view.bounds.size.width;
        
        for (MusicNoteButton *btn in curRunningArr) {
            int posx = screenWid/4*btn.pos;
            int posy = (curTime - btn.note.showTime) * speed;
            
//            printf("%d %d\n",posx, posy);
            
            CGRect frame = btn.frame;
            frame.origin.x = posx;
            frame.origin.y = posy;
            btn.frame = frame;
            
            if (btn.frame.origin.y > ScreenHeight-btnHeight) {
                btn.alpha = 1.3 - (btn.frame.origin.y-ScreenHeight+btnHeight) / btnHeight;
            }
        }
    }
    
    curTime += timerDuration;
}


- (IBAction)plsyModeBtnClked:(id)sender {
    
    flagPlayMode = !flagPlayMode;
    if (flagPlayMode) {
        [self.plsyModeBtn setTitle:@"游戏模式"];
    }else{
        [self.plsyModeBtn setTitle:@"播放模式"];
    }
}

- (IBAction)backBtnClked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
