//
//  MLogoutService.h
//  iRadio
//
//   on 14-7-2.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpServiceDelegate.h"
#import "MApi.h"

@interface MLogoutService : MApi

- (void)logoutService:(NSString *)session;

@end
