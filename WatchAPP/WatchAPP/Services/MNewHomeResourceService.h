//
//  MMessageService.h
//  WatchAPP
//
//  Created by wangweike
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MApi.h"

@interface MNewHomeResourceService : MApi
- (void)requestHomeResourceNewByUpImageData:(NSData*)imageData content:(NSString *)content;
@end
