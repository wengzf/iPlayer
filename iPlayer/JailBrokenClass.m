//
//  JailBrokenClass.m
//  iPlayer
//
//  Created by 翁志方 on 16/7/24.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "JailBrokenClass.h"

#import <sys/stat.h>


@implementation JailBrokenClass

+(BOOL)isJailbroken{
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]){
        return YES;
    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]){
        
        return YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]){
        
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/User/Applications/"
                                                                               error:nil];
        if ([applist count] > 0) {
            return YES;
        }
    }
    
    struct stat stat_info;
    if (0 == stat("/Applications/Cydia.app", &stat_info)) {
        return YES;
    }

    return NO;
}

@end
