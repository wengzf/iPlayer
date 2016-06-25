//
//  UIImageView+Extension.m
//  Pods
//
//  Created by 翁志方 on 16/1/5.
//
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)




- (void)setImageName:(NSString *)imageName
{
    self.image = [UIImage imageNamed:imageName];
}

@end
