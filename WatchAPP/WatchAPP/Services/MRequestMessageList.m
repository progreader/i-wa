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
-(void) requestMessageList{
    HttpQuery *query = [self newQuery];
    [self getWithPath:[PATH stringByAppendingString:@"list"] andQuery:query];
    NSLog(@"获取信息列表");
    
}
@end
