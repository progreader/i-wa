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

@interface MSleepdataService : MApi

- (void)requestSleepDataByDeviceId:(NSString *)deviceId;

@end
