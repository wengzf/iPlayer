//
//  NSObject+NSJSONSerialization.m
//  Deyes
//
//  Created by YAN LIU on 9/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "NSObject+NSJSONSerialization.h"

@implementation NSObject (NSObject_NSJSONSerializationWriting)

- (NSString *)JSONRepresentation {
    NSError * error = nil;
    NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];    
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (error)
        NSLog(@"-JSONRepresentation failed. Error is: %@", error);
    return json;
}

@end



@implementation NSString (NSString_NSJSONSerializationParsing)

- (id)JSONValue {
    NSError * error = nil;
    NSDictionary * bodyDic = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    if (error)
        NSLog(@"-JSONValue failed. Error is: %@", error);
    return bodyDic;
}

@end



@implementation NSData (NSData_NSJSONSerializationParsing)

- (id)JSONValue {
    NSError * error = nil;
    NSDictionary * bodyDic = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    if (error)
        NSLog(@"-JSONValue failed. Error is: %@", error);
    return bodyDic;
}

@end























