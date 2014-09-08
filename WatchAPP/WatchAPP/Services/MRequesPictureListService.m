//
//  MRequestMessageList.m
//  WatchAPP
//
//  Created by wangweike
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MRequesPictureListService.h"

@implementation MRequesPictureListService
static NSString *PATH = @"/api/mediapage/list/?created_by=%@";
-(void) requestListWithPersonId:(NSString*)personId;
{
    HttpQuery *query = [self newQuery];
    NSString* path=[NSString stringWithFormat:PATH,personId];
    [self getWithPath:path andQuery:query];
    NSLog(@"获取列表");
    
}
@end
