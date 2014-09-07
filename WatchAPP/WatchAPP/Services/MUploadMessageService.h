//
//  MMessageService.h
//  WatchAPP
//
//  Created by 谷少鹏  on 14-9-5. 消息服务类头文件
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MApi.h"

@interface MUploadMessageService : MApi
- (void)requestMessageNewByUpfile:(NSString *)upfile recipient:(NSString *)recipient;
@end
