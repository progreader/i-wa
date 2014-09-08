//
//  MNewPageService.h
//  WatchAPP
//
//  Created by mac  on 14-9-8.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MApi.h"

@interface MRequestNewPageService : MApi
- (void)requestNewPageByUpfile:(NSString *)upfile subject:(NSString *)subject;
@end
