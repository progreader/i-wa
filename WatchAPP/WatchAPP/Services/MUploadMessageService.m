//
//  MMessageService.m
//  WatchAPP
//
//  Created by 谷少鹏  on 14-9-5.消息服务类实现文件
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MUploadMessageService.h"

@implementation MUploadMessageService
// PATH
static NSString *PATH = @"/api/message/new";

- (void)requestMessageNewByUpfile:(NSString *)upfile recipient:(NSString *)recipient{
    
    NSString *fileName=[upfile lastPathComponent];
    NSData *amrData = [NSData dataWithContentsOfFile:upfile];
    
    HttpQuery *query = [self newQuery];
    [query addParam:@"recipient" andValue:recipient];
    [query addParam:@"subject" andValue:@"测试"];
    [self postWithPath:PATH andQuery:query andAttachments:[NSDictionary dictionaryWithObject:amrData forKey:fileName]];
}

@end
