//
//  RootTableViewController.h
//  iPlayer
//
//  Created by 翁志方 on 16/9/8.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RootCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;


@end

@interface RootTableViewController : UITableViewController

@end
