//
//  MRequestMessageList.h
//  WatchAPP
//
//  Created by mac  on 14-9-5.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MApi.h"

@interface MRequestMessageList : MApi
-(void) requestMessageListByPage:(NSNumber *)page;
@end
