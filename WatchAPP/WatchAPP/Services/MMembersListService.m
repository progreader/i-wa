//
//  MMembersListService.m
//  WatchAPP
//  获取家庭圈成员的信息
//  Created by mac  on 14-9-6.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MMembersListService.h"

@implementation MMembersListService
static NSString *PATH = @"/api/person/self";
static NSString *PATH2 = @"/api/group/";
-(void) requestHomeInfo{
//    HttpQuery *query = [self newQuery];
    [self getWithPath:PATH andQuery:nil];
    NSLog(@"获取信息列表");
}
-(void) requestGroupInfoById:(NSString *)groupID{
    [self getWithPath:[PATH2 stringByAppendingString:groupID ] andQuery:nil];
    NSLog(@"获取信息列表");

}
@end
