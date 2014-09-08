//
//  MMessageService.m
//  WatchAPP
//
//  Created by wangweike
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MSupportHomeResourceService.h"

@implementation MSupportHomeResourceService
// PATH
static NSString *PATH = @"/api/page/%@/%@";

- (void)submitSupportPageId:(NSString*)pageId support:(BOOL)support
{
    HttpQuery *query = [self newQuery];
    NSString* path=nil;
    if(support)
    {
        path=[NSString stringWithFormat:PATH,pageId,@"star"];
    }
    else
    {
        path=[NSString stringWithFormat:PATH,pageId,@"unstar"];
    }
    [self postWithPath:path andQuery:query];
}

@end
