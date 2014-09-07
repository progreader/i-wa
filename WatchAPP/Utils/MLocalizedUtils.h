//
//  MLocalizedUtils.h
//  
//
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

#define MLocalizedString(key) [MLocalizedUtils stringWithKey:key]
#define MLocalizedStringLowerCase(key) [MLocalizedUtils stringWithKeyLowerCase:key]
#define MLocalizedStringUpperCase(key) [MLocalizedUtils stringWithKeyUpperCase:key]

@interface MLocalizedUtils : NSObject

+ (NSString *)stringWithKey:(NSString *)key;
+ (NSString *)stringWithKeyLowerCase:(NSString *)key;
+ (NSString *)stringWithKeyUpperCase:(NSString *)key;

@end
