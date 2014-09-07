//
//  MMobileLoginService.m
//  iRadio
//
//   14-5-9.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MGetLocationFromUnitComService.h"

@implementation MGetLocationFromUnitComService

// PATH
static NSString *PATH = @"/api/getLocation.action";

// PARAMETERS
static NSString *PHONE = @"phone";
static NSString *CLIENT = @"client";
static NSString *PASSWORD = @"password";

- (void)requestGetLocationByPhone:(NSString *)phone clinet:(NSString *)clinet password:(NSString *)password
{
    HttpQuery *query = [self newQuery];
    [query addParam:PHONE andValue:phone];
    [query addParam:CLIENT andValue:clinet];
    [query addParam:PASSWORD andValue:password];

    [self getWithPath:PATH andQuery:query];
}

@end
