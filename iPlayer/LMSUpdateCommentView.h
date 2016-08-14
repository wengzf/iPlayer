//
//  LMSUpdateCommentView.h
//  FireShadow
//
//  Created by 翁志方 on 15/9/26.
//  Copyright (c) 2015年 Yonglibao. All rights reserved.
//

#import <UIKit/UIKit.h>

//   设置 jumpToActivity   调用 showWithSting

@interface LMSUpdateCommentView : UIView
{
}


@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;



- (void)showWithSting:(NSString *) contentStr canExit:(BOOL) canExit;


@end
