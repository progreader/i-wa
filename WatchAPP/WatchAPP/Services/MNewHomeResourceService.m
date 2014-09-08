//
//  MMessageService.m
//  WatchAPP
//
//  Created by wangweike
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import "MNewHomeResourceService.h"

@implementation MNewHomeResourceService
// PATH
static NSString *PATH = @"/api/page/new";

- (void)requestHomeResourceNewByUpImageData:(NSData*)imageData content:(NSString *)content{
    
    //NSString *fileName=[upfile lastPathComponent];
    //NSData *fileData = [NSData dataWithContentsOfFile:upfile];
    
    HttpQuery *query = [self newQuery];
    [query addParam:@"subject" andValue:@"subject"];
    [query addParam:@"body" andValue:content];
    
    if(imageData)
    {
        [self postWithPath:PATH andQuery:query constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"upfile" fileName:@"image.jpg" mimeType:@"image/jpg"];
        }];
    }
    else
    {
        [self postWithPath:PATH andQuery:query];
    }
}

@end
