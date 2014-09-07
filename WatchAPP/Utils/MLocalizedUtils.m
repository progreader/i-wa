//
//  MLocalizedUtils.m
//  
//
//  Copyright (c) 2014 . All rights reserved.
//

#import "MLocalizedUtils.h"

@implementation MLocalizedUtils

+ (NSString *)stringWithKey:(NSString *)key
{
    return NSLocalizedString(key, nil);
}

+ (NSString *)stringWithKeyLowerCase:(NSString *)key
{
    return [[self stringWithKey:key] lowercaseString];
}

+ (NSString *)stringWithKeyUpperCase:(NSString *)key
{
    return [[self stringWithKey:key] uppercaseString];
}

@end
