//
//  MLogoutService.m
//  iRadio
//
//   on 14-7-2.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MLogoutService.h"

@implementation MLogoutService

// PATH
static NSString *PATH = @"/loginApp.action";

- (void)logoutService:(NSString *)session{
    HttpQuery *query = [self newQuery];
    [self getWithPath:[PATH stringByAppendingString:[NSString stringWithFormat:@";jsessionid=%@",session]] andQuery:query];
}

@end
