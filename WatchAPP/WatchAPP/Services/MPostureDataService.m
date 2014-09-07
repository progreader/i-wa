//
//  MMobileLoginService.m
//  iRadio
//
//   14-5-9.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MPostureDataService.h"

@implementation MPostureDataService

// PATH
static NSString *PATH = @"/api/posturedata/";

// PARAMETERS
static NSString *DEVICE_ID = @"device";

- (void)requestPostureDataByDeviceId:(NSString *)deviceId
{
    HttpQuery *query = [self newQuery];
    [query addParam:DEVICE_ID andValue:deviceId];
    
    [self getWithPath:PATH andQuery:query];
}

@end
