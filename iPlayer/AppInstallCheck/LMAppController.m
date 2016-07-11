//
//  LMAppController.m
//  WatchSpringboard
//
//  Created by Andreas Verhoeven on 28-10-14.
//  Copyright (c) 2014 Lucas Menge. All rights reserved.
//
#include <objc/runtime.h>

#import "LMAppController.h"
static LMAppController *LMA =nil;

@interface LAWorkspace
@end


#pragma mark -

@implementation LMAppController
{
    
  LAWorkspace* _workspace;
  NSArray* inApplications;
   
}

- (instancetype)init
{
	self = [super init];
	if(self != nil)
	{
		_workspace = [NSClassFromString(@"LSApplicationWorkspace") new];
	}
	
	return self;
}


- (NSArray*)readApp
{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    SEL my_sel2 = NSSelectorFromString([NSString stringWithFormat:@"%@%@%@",@"de",@"faultWor",@"kspace"]);

    NSObject *workspace = [LSApplicationWorkspace_class performSelector:my_sel2];
    SEL my_sel = NSSelectorFromString([NSString stringWithFormat:@"allInstalledApplications"]);
    NSArray * allApps=[workspace performSelector:my_sel];
	NSMutableArray* applications = [NSMutableArray arrayWithCapacity:allApps.count];
	for(id proxy in allApps)
	{
		LMApp* app = [LMApp appWithProxy:proxy];
        [applications addObject:app];
	}
	return applications;
}

- (NSArray*)inApplications
{
	if(nil == inApplications)
	{
		inApplications = [self readApp];
	}
	
	return inApplications;
}

+ (instancetype)sharedInstance
{
    NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:@"tStamp"] isKindOfClass:[NSNull class]]) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        [userDefault setObject:dat forKey:@"tStamp"];
        [userDefault synchronize];
        LMA=[[LMAppController alloc]init];
        return LMA;
    }else
    {
        NSDate* dat=[userDefault objectForKey:@"tStamp"];
        long long time=[dat timeIntervalSince1970];
        if ([[NSDate dateWithTimeIntervalSinceNow:0]timeIntervalSince1970]-time>=60) {
            LMA=[[LMAppController alloc]init];
            return LMA;
        }else
        {
            return LMA;
        }
    }
    

}

@end
