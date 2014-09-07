//
//  MMobileLoginService.m
//  iRadio
//
//   14-5-9.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "MEditPersonService.h"

@implementation MEditPersonService

// PATH
static NSString *PATH = @"/api/person/%@/edit";

// PARAMETERS
static NSString *SOS_NUMBER_1 = @"sos_number1";
static NSString *SOS_NUMBER_2 = @"sos_number2";
static NSString *SOS_NUMBER_3 = @"sos_number3";
static NSString *SOS_NUMBER_4 = @"sos_number4";

- (void)requestEditPersonByPersonId:(NSString *)personId sosNumber1:(NSString *)sosNumber1 sosNumber2:(NSString *)sosNumber2 sosNumber3:(NSString *)sosNumber3 sosNumber4:(NSString *)sosNumber4
{
    HttpQuery *query = [self newQuery];
    [query addParam:SOS_NUMBER_1 andValue:sosNumber1];
    [query addParam:SOS_NUMBER_2 andValue:sosNumber2];
    [query addParam:SOS_NUMBER_3 andValue:sosNumber3];
    [query addParam:SOS_NUMBER_4 andValue:sosNumber4];
    
    NSString *path2 = [NSString stringWithFormat:PATH, personId];
    [self postWithPath:path2 andQuery:query];
}

@end
