//
//  UIBaseTableViewCell.h
//  CashMaker
//
//  Created by 翁志方 on 16/4/11.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseModel.h"

@interface UIBaseTableViewCell : UITableViewCell

- (void)updateCellWithModel:(BaseModel *)model;

@end
