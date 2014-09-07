//
//  MMobileLoginService.h
//  iRadio
//
//   14-5-9.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpServiceDelegate.h"
#import "MApi.h"

@interface MEditPersonService : MApi

- (void)requestEditPersonByPersonId:(NSString *)personId sosNumber1:(NSString *)sosNumber1 sosNumber2:(NSString *)sosNumber2 sosNumber3:(NSString *)sosNumber3 sosNumber4:(NSString *)sosNumber4;

@end
