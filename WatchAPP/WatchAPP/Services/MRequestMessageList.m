//
//  MRequestMessageList.m
//  WatchAPP
//
//  Created by mac  on 14-9-5.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MRequestMessageList.h"

@implementation MRequestMessageList
static NSString *PATH = @"/api/message/";
-(void) requestMessageListByPage:(NSNumber *)page{
    HttpQuery *query = [self newQuery];
    [query addParam:@"page" andValue:page];
    NSString *requestPath=[PATH stringByAppendingString:@"list"];
    [self getWithPath:requestPath andQuery:query];
    NSLog(@"获取信息列表");
    
}
@end
