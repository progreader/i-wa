//
//  MMobileLoginService.m
//  iRadio
//
//   14-5-9.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MEditDeviceService.h"

@implementation MEditDeviceService

// PATH
static NSString *PATH = @"/api/auth/rest";

// PARAMETERS
static NSString *EMAIL = @"email";

- (void)requestResetPasswordByEmail:(NSString *)email
{
    HttpQuery *query = [self newQuery];
    [query addParam:EMAIL andValue:email];
    
    [self postWithPath:PATH andQuery:query];
}

@end
