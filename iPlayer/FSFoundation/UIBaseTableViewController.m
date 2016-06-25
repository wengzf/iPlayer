//
//  UIBaseTableViewController.m
//  FireShadow
//
//  Created by 翁志方 on 15/8/20.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#import "UIBaseTableViewController.h"

@interface UIBaseTableViewController ()

@end

@implementation UIBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航栏左侧
    {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 71, 33)];
        UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 9, 18)];
        leftImg.image = [UIImage imageNamed:@"icon_back"];
        [leftView addSubview:leftImg];
        
        UITapGestureRecognizer *leftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(leftBarButtonItemClked:)];
        [leftView addGestureRecognizer:leftGesture];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBarButtonItemClked:(id)sender
{
    if (self.navigationController && [self.navigationController.viewControllers firstObject]!=self) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}

- (void)setNilLeftBar
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleBordered target:nil action:NULL];
    self.navigationItem.leftBarButtonItem = item;
}

@end
