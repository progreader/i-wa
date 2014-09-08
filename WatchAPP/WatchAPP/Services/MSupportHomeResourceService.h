//
//  MMessageService.h
//  WatchAPP
//
//  Created by wangweike
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MApi.h"

@interface MSupportHomeResourceService : MApi
- (void)submitSupportPageId:(NSString*)pageId support:(BOOL)support;
@end
