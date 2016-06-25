//
//  NSObject+NSJSONSerialization.h
//  Deyes
//
//  Created by YAN LIU on 9/25/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark JSON Writing

// Adds JSON generation to NSObject
@interface NSObject (NSObject_NSJSONSerializationWriting)


- (NSString *)JSONRepresentation;

@end


#pragma mark JSON Parsing

// Adds JSON parsing methods to NSString
@interface NSString (NSString_NSJSONSerializationParsing)

- (id)JSONValue;

@end

// Adds JSON parsing methods to NSData
@interface NSData (NSData_NSJSONSerializationParsing)

- (id)JSONValue;

@end

