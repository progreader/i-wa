//
//  MRequestPageListService.m
//  WatchAPP
//
//  Created by mac  on 14-9-8.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MRequestPageListService.h"

@implementation MRequestPageListService
static NSString *PATH = @"/api/page/list";
-(void) requestPageListByPage:(NSNumber *)page{
    [self getWithPath:PATH andQuery:nil];
    NSLog(@"获取组信息列表");
}
@end
