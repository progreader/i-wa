//
//  MXMLReader.h
//  
//
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXMLReader : NSObject
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)errorPointer;

@end