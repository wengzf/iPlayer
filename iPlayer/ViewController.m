//
//  ViewController.m
//  iPlayer
//
//  Created by 翁志方 on 15/12/5.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "ViewController.h"
#import "MusicPlayViewController.h"

@interface ViewController ()
{
    MusicRule *musicRule;
    NSMutableArray *musicNoteArr;
    
    
    // 所有音的文件名
    NSMutableArray *pitchFileNameArr;
    
    // 调性 基准偏移
    int basePitchOffset;
    
    AVAudioPlayer *pitchPlayer;
    
    NSArray *musicNames;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 音乐文件名初始化
    musicNames = @[@"如意玉儿曲",
                   @"穿越时空的思念",
                   @"梁祝",
                   @"茉莉花",
                   @"菊花台",
                   
                   @"送别",
                   @"花儿为什么这样红",
                   @"天空之城",
                   @"雨的印记",
                   @"斯卡保罗集市",
                   
                   @"少女的祈祷",
                   @"土耳其进行曲",
                   @"秋日私语",
                   @"克罗地亚狂想曲",
                   @"爱的罗曼斯",
                   
                   @"樱花",
                   @"赛马",
                   @"草原英雄小姐妹",
                   @"莫斯科郊外的晚上",
                   @"飘落"];
    
}
- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSIndexPath *inxPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self tableView:[UITableView new] didSelectRowAtIndexPath:inxPath];
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 文件读取

- (NSArray *) numbersFromFileName:(NSString *) fileName
{
    // 文件读取操作
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // 从文件中抽出所有数字
    NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *numArr = [str componentsSeparatedByCharactersInSet:cs];

    NSMutableArray *resArr = [NSMutableArray array];
    for (NSString *str in numArr){
        if (str.length > 0 ) {
            [resArr addObject:str];
        }
    }
    return resArr;
}

- (void) analysisMusicFileForIntegerStringArr:(NSArray *) numArr
{
    // 初始化声音名字文件
    // 从24号到108号确定一个数组，对应所有的文件名   num->filename
    NSArray *pitchNameArr = @[@"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B"];
    
    pitchFileNameArr = [NSMutableArray array];
    for (int i=0; i<23; ++i) {
        [pitchFileNameArr addObject:@""];
    }
    for (int i=24; i<109; ++i) {
        
        NSString  *str = [NSString stringWithFormat:@"%03d_%@%dKM56_M", i,pitchNameArr[i%12],(i-24)/12];
        [pitchFileNameArr addObject:str];
    }
    
    // 按照格式要求开始读入数字
    // 跳过第一个数字文件版本号
    musicRule = [MusicRule new];
    musicRule.pitchSymbol = [numArr[1] intValue];
    musicRule.pitchName = [numArr[2] intValue];
    musicRule.beatPerSection = [numArr[3] intValue];
    musicRule.notePerBeat = [numArr[4] intValue];
    musicRule.beatPerMinute = [numArr[5] intValue];
    musicRule.baseUnitNum = [numArr[6] intValue];
    
    [musicRule calculateBaseUnitTime];
    
    
    // 确定基准音调偏移
    int arrPitch[] = {0, 0, 2, 4, 5, 7, 9, 11};

    basePitchOffset = arrPitch[musicRule.pitchName] + 72;
    
    if (musicRule.pitchSymbol==1){
        --basePitchOffset;
    }else if (musicRule.pitchSymbol==2){
        ++basePitchOffset;
    }
    
    // 读入每一个音符知道文件结束
    
    double curTime = 0;
    musicNoteArr = [NSMutableArray array];
    for (int i=7; i<numArr.count; i+=2) {

        int pitch = [numArr[i] intValue];
        int timeLen = [numArr[i+1] intValue];
        
        MusicNote *musicNote = [MusicNote new];
        musicNote.pitchSymbol = pitch/100;
        
        musicNote.pitchLevel = pitch%100/10;
        musicNote.pitchLevel = pitch<0 ? -(musicNote.pitchLevel+1):  musicNote.pitchLevel;
        
        musicNote.pitchName = abs(pitch%10);
        
        musicNote.duration = timeLen;
        
        // 计算实际时间
        musicNote.realDuration = musicNote.duration * musicRule.baseUnitTime;
        
        musicNote.showTime = curTime;
        
        curTime += musicNote.realDuration;
        
        [musicNoteArr addObject:musicNote];
    }
}

- (NSString *) parsePitch:(MusicNote *) note
{
    // 确定音符偏移  72 c4    sabc  s符号位    a升降号   b所在音层级    c唱名
    int arrPitch[] = {0, 0, 2, 4, 5, 7, 9, 11};
    int pitchOffset = basePitchOffset;
    
    if (note.pitchSymbol==1){        // 降调
        --pitchOffset;
    }else if (note.pitchSymbol==2){  // 升调
        ++pitchOffset;
    }
    
    pitchOffset += 12*note.pitchLevel;
    
    pitchOffset += arrPitch[note.pitchName];
    
    //  1. 根据调性确定 dou的基本号数位置
    //  2. 计算音符相对 dou的基本偏移     可以在初始化的时候就计算出来
    
    NSString *pitchFileName = pitchFileNameArr[pitchOffset];
    
    return pitchFileName;
}

// 按顺序播放音频文件
- (void) musicEvent:(int) noteIndex
{
    if (noteIndex >= musicNoteArr.count) {
        return;
    }
    
    MusicNote *note = musicNoteArr[noteIndex];
    
    // 播放音高文件名解析
    NSString *pitchFileName = [self parsePitch:note];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:pitchFileName ofType:@"mp3"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSError *err;
    pitchPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&err];
    [pitchPlayer prepareToPlay];
    [pitchPlayer play];
    // 根据musicRule和musicNoteArr[noteIndex] 解析出第一个播放的文件
    // 对应的音高和时值
    
    // 延迟时值后递归调用
    // 播放时值解析
    double popTime = dispatch_time(DISPATCH_TIME_NOW, note.realDuration * NSEC_PER_SEC );
    
    printf("%lf\n",popTime);
    dispatch_after(popTime, dispatch_get_global_queue(0, 0), ^{
        [self musicEvent:noteIndex+1];
    });
}

#pragma mark -  UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return musicNames.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = musicNames[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = musicNames[indexPath.row];
    
    NSArray *numArr = [self numbersFromFileName:str];
    
    [self analysisMusicFileForIntegerStringArr:numArr];
//    [self musicEvent:0];
    
    MusicPlayViewController *vc = [[MusicPlayViewController alloc] init];
    vc.musicRule = musicRule;
    vc.musicNoteArr = musicNoteArr;
    
    vc.basePitchOffset = basePitchOffset;
    vc.pitchFileNameArr = pitchFileNameArr;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
