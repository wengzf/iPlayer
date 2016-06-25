//
//  NSDate+ToString.m
//  WhiteSharkBusiness
//
//  Created by 翁志方 on 15/12/28.
//  Copyright © 2015年 wzf. All rights reserved.
//

#import "NSDate+ToString.h"

@implementation NSDate (ToString)


- (NSString *) toString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:self];
}

@end
