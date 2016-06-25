//
//  BaseModel.m
//  CashMaker
//
//  Created by 翁志方 on 16/4/11.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel



- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self fillWithDic:dic];
    }
    return self;
}


@end
