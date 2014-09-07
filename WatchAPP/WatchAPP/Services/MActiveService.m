//
//  MMobileLoginService.m
//  iRadio
//
//   14-5-9.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MActiveService.h"

@implementation MActiveService

// PATH
static NSString *PATH = @"/api/person/active";

// PARAMETERS
static NSString *DEVICE_ID = @"deviceid";
static NSString *SIM_PHONE = @"sim_phone";
static NSString *SIM_PHONE_TYPE = @"sim_phone_type";

- (void)requestActiveByDeviceId:(NSString *)deviceId simPhone:(NSString *)simPhone simPhoneType:(NSString *)simPhoneType
{
    HttpQuery *query = [self newQuery];
    [query addParam:DEVICE_ID andValue:deviceId];
    [query addParam:SIM_PHONE andValue:simPhone];
    [query addParam:SIM_PHONE_TYPE andValue:simPhoneType];
    
    [self postWithPath:PATH andQuery:query];
}

@end
