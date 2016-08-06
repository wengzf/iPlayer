//
//  KeyViewController.h
//  iPlayer
//
//  Created by 翁志方 on 16/6/25.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YingYongYuanjAppInfo.h"

#define ShareKeyViewController [KeyViewController shareInstance]


@interface KeyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *startMakeMoneyBtn;

- (IBAction)startMakeMoneyBtnClked:(id)sender;


- (void)login;

- (void)startMonitor;

- (void)receiveMessage:(id)message;



@end

