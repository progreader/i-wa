//
//  HttpServiceResult.h
//  
//
//  Copyright (c) 2013 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpServiceResult : NSObject

@property (nonatomic) int resultCode;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) id data;

@end

