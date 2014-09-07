//
//  MMessageService.h
//  WatchAPP
//
//  Created by wwk  on 14-9-5. 消息服务类头文件
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MApi.h"

@interface MNewHomeResourceService : MApi
- (void)requestHomeResourceNewByUpImageData:(NSData*)imageData content:(NSString *)content;
@end
