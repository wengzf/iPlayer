//
//  BaseModel.h
//  CashMaker
//
//  Created by 翁志方 on 16/4/11.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject



- (id)initWithDic:(NSDictionary *)dic;

// override
- (void)fillWithDic:(NSDictionary *)dic;


@end
