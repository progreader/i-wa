//
//  MMobileLoginService.m
//  iRadio
//
//   14-5-9.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MMobileLoginService.h"

@implementation MMobileLoginService

// PATH
static NSString *PATH = @"/api/auth/login";

// PARAMETERS
static NSString *USERNAME = @"username";
static NSString *PASSWORD = @"password";

- (void)requestMobleLoginByUsername:(NSString *)username password:(NSString *)password
{
    HttpQuery *query = [self newQuery];
    [query addParam:USERNAME andValue:username];
    [query addParam:PASSWORD andValue:password];
    
    [self postWithPath:PATH andQuery:query];
}

@end
