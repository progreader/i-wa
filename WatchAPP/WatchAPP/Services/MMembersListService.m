//
//  MMembersListService.m
//  WatchAPP
//  获取家庭圈成员的信息
//  Created by mac  on 14-9-6.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MMembersListService.h"

@implementation MMembersListService
static NSString *PATH = @"/api/group/";
-(void) requestHomeMembersListByUserID:(NSString *)userID{
    HttpQuery *query = [self newQuery];
    [self getWithPath:[PATH stringByAppendingString:userID] andQuery:query];
    NSLog(@"获取信息列表");
}
@end
