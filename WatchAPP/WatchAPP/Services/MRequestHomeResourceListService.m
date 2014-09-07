//
//  MRequestMessageList.m
//  WatchAPP
//
//  Created by wwk  on 14-9-5.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MRequestHomeResourceListService.h"

@implementation MRequestHomeResourceListService
static NSString *PATH = @"/api/page/list";
-(void) requestList{
    HttpQuery *query = [self newQuery];
    [self getWithPath:PATH andQuery:query];
    NSLog(@"获取列表");
    
}
@end
