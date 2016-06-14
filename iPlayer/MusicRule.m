//
//  MusicRule.m
//  iPlayer
//
//  Created by 翁志方 on 15/12/5.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "MusicRule.h"

@implementation MusicRule



- (void) calculateBaseUnitTime
{
    self.baseUnitTime = 60.0 / self.beatPerMinute / 16.0 * self.baseUnitNum;
}


@end
