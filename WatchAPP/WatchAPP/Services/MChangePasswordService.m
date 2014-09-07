//
//  MMobileLoginService.m
//  iRadio
//
//   14-5-9.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MChangePasswordService.h"

@implementation MChangePasswordService

// PATH
static NSString *PATH = @"/api/person/change_passwd";

// PARAMETERS
static NSString *OLD_PASSWORD = @"old_password";
static NSString *PASSWORD = @"password";

- (void)requestChangePassword:(NSString *)oldPassword password:(NSString *)password
{
    HttpQuery *query = [self newQuery];
    [query addParam:OLD_PASSWORD andValue:oldPassword];
    [query addParam:PASSWORD andValue:password];
    
    [self postWithPath:PATH andQuery:query];
}

@end
