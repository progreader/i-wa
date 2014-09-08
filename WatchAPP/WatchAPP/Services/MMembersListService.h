//
//  MMembersListService.h
//  WatchAPP
//
//  Created by mac  on 14-9-6.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MApi.h"

@interface MMembersListService : MApi
-(void) requestHomeInfo;
-(void) requestGroupInfoById:(NSString *)groupID;
@end
