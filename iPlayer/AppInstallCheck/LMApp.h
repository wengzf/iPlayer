//
//  LMApp.h
//  WatchSpringboard
//
//  Created by Andreas Verhoeven on 28-10-14.
//  Copyright (c) 2014 Lucas Menge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LMApp : NSObject

@property (nonatomic, strong) NSString* bunidfier;

@property (nonatomic, strong) NSString *appSID;
@property (nonatomic, strong) NSString *appName;

@property (nonatomic) BOOL isHiApp;

+ (instancetype)appWithProxy:(id)Proxy;



@end
