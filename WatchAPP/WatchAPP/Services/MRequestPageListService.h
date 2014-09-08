//
//  MRequestPageListService.h
//  WatchAPP
//
//  Created by mac  on 14-9-8.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MApi.h"

@interface MRequestPageListService : MApi
-(void) requestPageListByPage:(NSNumber *)page;
@end
