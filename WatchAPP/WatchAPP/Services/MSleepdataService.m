//
//  MMobileLoginService.m
//  iRadio
//
//   14-5-9.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MSleepdataService.h"

@implementation MSleepdataService

// PATH
static NSString *PATH = @"/api/sleepdata/";

// PARAMETERS
static NSString *DEVICE_ID = @"device";

- (void)requestSleepDataByDeviceId:(NSString *)deviceId
{
    HttpQuery *query = [self newQuery];
    [query addParam:DEVICE_ID andValue:deviceId];
    
    [self getWithPath:PATH andQuery:query];
}

@end
