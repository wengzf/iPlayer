//
//  GuideViewController.h
//  Recommend
//
//  Created by 翁志方 on 16/9/8.
//  Copyright © 2016年 翁志方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController

@property (nonatomic, strong) NSString *desStr1;
@property (nonatomic, strong) NSString *desStr2;
@property (nonatomic, strong) NSString *qaStr;



@property (weak, nonatomic) IBOutlet UILabel *desLabel1;

@property (weak, nonatomic) IBOutlet UILabel *desLabel2;

@property (weak, nonatomic) IBOutlet UIImageView *qaCodeImageView;


@end
