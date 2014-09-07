//
//  MDownloadMessageService.m
//  WatchAPP
//
//  Created by mac  on 14-9-5.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MDownloadMessageService.h"

@implementation MDownloadMessageService
// PATH
static NSString *PATH = @"/api/message/";
- (void) requestMessageByID:(NSString *)msgID{
    HttpQuery *query = [self newQuery];
    [self getWithPath:[PATH stringByAppendingString:msgID] andQuery:query];
    NSLog(@"获取语音");
}

@end
