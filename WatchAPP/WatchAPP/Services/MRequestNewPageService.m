//
//  MNewPageService.m
//  WatchAPP
//
//  Created by mac  on 14-9-8.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MRequestNewPageService.h"

@implementation MRequestNewPageService

static NSString *PATH = @"/api/page/new";

- (void)requestNewPageByUpfile:(NSString *)upfile subject:(NSString *)subject{
    NSString *fileName=[upfile lastPathComponent];
    NSData *amrData = [NSData dataWithContentsOfFile:upfile];
    if(amrData==nil)
    {
        NSLog(@"没有读取到amr文件，上传失败!");
        return;
    }
    HttpQuery *query = [self newQuery];
    [query addParam:@"body" andValue:fileName];
    [query addParam:@"subject" andValue:subject];
    [self postWithPath:PATH andQuery:query andAttachments:[NSDictionary dictionaryWithObject:amrData forKey:fileName]];
}
@end
