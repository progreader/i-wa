//
//  HttpServiceDelegate.h
//  
//
//  Copyright (c) 2013 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpServiceResult.h"
#import "HttpQuery.h"

#define NO_ERROR            0;
#define CONNECTION_ERROR    1;
#define SERVER_ERROR        2;
#define DATA_ERROR          4;

@protocol HttpServiceCallback

- (void)responded:(HttpServiceResult *)result ofSid:(NSString *)sid;

@optional
- (id)mapping:(NSString *)resultValue ofSid:(NSString *)sid;

@end

@interface HttpServiceDelegate : NSObject

@property (strong, nonatomic) NSString *urlString;

- (id)initWithUrlString: (NSString *)urlString;
- (void)putWithPath:(NSString *)path andQuery:(HttpQuery *)query andCallback:(NSObject<HttpServiceCallback> *)callback forSid:(NSString *)sid forHttpHeader:(NSDictionary*)httpHeader;
- (void)getWithPath:(NSString *)path andQuery:(HttpQuery *)query andCallback:(NSObject<HttpServiceCallback> *)callback forSid:(NSString *)sid;
- (void)postWithPath:(NSString *)path andQuery:(HttpQuery *)query andCallback:(NSObject<HttpServiceCallback> *)callback forSid:(NSString *)sid;
- (void)postWithPath:(NSString *)path andQuery:(HttpQuery *)query andAttachments:(NSDictionary *)attachments andCallback:(NSObject<HttpServiceCallback> *) callback forSid:(NSString *)sid;
- (void)setMaxConcurrentOperationsCount:(int)count;

@end
