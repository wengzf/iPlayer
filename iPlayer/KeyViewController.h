//
//  KeyViewController.h
//  iPlayer
//
//  Created by 翁志方 on 16/6/25.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ShareKeyViewController [KeyViewController shareInstance]


@interface KeyViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)backBtnClked:(id)sender;


+ (KeyViewController *)shareInstance;

- (void)show;


- (void)loginWithID:(NSString *)strID;

- (void)getTaskList;

- (void)acceptTask;

- (void)openTask;

- (void)uploadTask;

- (void)share;


@end



//1. 通过app登录
//shoujizhuan://native/login
//
//2. 通过app获取任务列表
//shoujizhuan://native/getTaskList
//
//3. 通过app接任务
//shoujizhuan://native/acceptTask?taskid=''
//
//4. 通过app打开任务App
//shoujizhuan://native/openTask?taskid=''
//
//5. 通过app提交任务
//shoujizhuan://native/uploadTask?taskid=''
//
//6. 通过app分享
//shoujizhuan://native/share
