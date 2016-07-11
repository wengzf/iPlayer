//
//  LMApp.m
//  WatchSpringboard
//
//  Created by Andreas Verhoeven on 28-10-14.
//  Copyright (c) 2014 Lucas Menge. All rights reserved.
//

#import "LMApp.h"


#pragma mark -

@interface PrivateProxy

@end

#pragma mark -

@implementation LMApp
{
	id  _applicationProxy;
}

- (NSString*)appName
{
    
    return [_applicationProxy valueForKey:@"localizedName"] ?:[_applicationProxy valueForKey:@"localizedShortName"] ;
}
- (NSString*)bunidfier
{
    
	return [_applicationProxy valueForKey:@"bundleIdentifier"];
}


- (NSString*)appSID
{
    return [_applicationProxy valueForKey:@"applicationDSID"];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@",self.appName,self.bunidfier,self.appSID];
}


- (id)initWithPrivateProxy:(id)privateProxy
{
  self = [super init];
  if(self != nil)
  {
      _applicationProxy = (PrivateProxy*)privateProxy;
    }
  
  return self;
}

+ (instancetype)appWithProxy:(id)Proxy;
{
  return [[self alloc] initWithPrivateProxy:Proxy];
}

@end
