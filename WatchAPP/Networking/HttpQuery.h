//
//  HttpQuery.h
//  
//
//  Copyright (c) 2013 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpQuery : NSObject

@property (strong, nonatomic) NSMutableDictionary *parameters;

- (void)addParam:(NSString *)param andValue:(id)value;

@end
