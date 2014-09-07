//
//  MMobileLoginService.m
//  iRadio
//
//   14-5-9.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MRegisterService.h"

@implementation MRegisterService

// PATH
static NSString *PATH = @"/api/auth/register";

// PARAMETERS
static NSString *USERNAME = @"username";
static NSString *PASSWORD = @"password";
static NSString *EMAIL = @"email";

- (void)requestRegisterByUsername:(NSString *)username password:(NSString *)password email:(NSString *)email
{
    HttpQuery *query = [self newQuery];
    [query addParam:USERNAME andValue:username];
    [query addParam:PASSWORD andValue:password];
    [query addParam:EMAIL andValue:email];
    
    [self postWithPath:PATH andQuery:query];
}

@end
