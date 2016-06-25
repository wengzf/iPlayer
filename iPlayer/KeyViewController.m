//
//  KeyViewController.m
//  iPlayer
//
//  Created by 翁志方 on 16/6/25.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "KeyViewController.h"
#import "FSNetworkManager.h"

@implementation KeyViewController



+ (KeyViewController *)shareInstance
{
    static KeyViewController *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[KeyViewController alloc] init];
    });
    
    return obj;
}


- (void)show
{
    self.view.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
}

- (void)viewDidLoad
{
    self.backBtn.layer.cornerRadius = 4;
    self.backBtn.layer.masksToBounds = YES;
}


- (IBAction)backBtnClked:(id)sender {
    
    // 打开赚么网页
    NSURL *url = [NSURL URLWithString:@"http://shoujizhuan.me"];
    [[UIApplication sharedApplication] openURL:url];
}



- (void)loginWithID:(NSString *)strID
{
    
}

- (void)getTaskList
{
    
}

- (void)acceptTask
{
    
}

- (void)openTask
{
    
}

- (void)uploadTask
{
    
}

- (void)share
{
    
}



@end
