//
//  HashUtils.h
//  
//
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HashUtils : NSObject

+ (NSString *)sha1:(NSString *)str;
+ (NSString *)md5Hash:(NSString *)str;

@end
