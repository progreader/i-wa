//
//  ZApi.h
//  iRadio
//
//  Copyright (c) 2013 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpServiceDelegate.h"
#import "HttpServiceResult.h"

@interface ServiceResult : NSObject

@property (nonatomic) BOOL hasError;
@property (strong, nonatomic) id data;
@property (strong, nonatomic) NSString *errorCode;
@property (strong, nonatomic) NSString *message;

@end

@protocol ServiceCallback<NSObject>

@required
- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid;

@end

@interface MApi : NSObject<HttpServiceCallback>

- (id)initWithSid:(NSString *)sid andCallback:(NSObject<ServiceCallback> *)callback;
- (id)initWithUrl:(NSString *)url sid:(NSString *)sid andCallback:(NSObject<ServiceCallback> *)callback;
- (HttpQuery *) newQuery;
- (void)putWithPath: (NSString *)path andQuery: (HttpQuery *)query andHttpHeader:(NSDictionary*)httpHeader;
- (void)getWithPath:(NSString *)path andQuery:(HttpQuery *)query;
- (void)postWithPath:(NSString *)path andQuery:(HttpQuery *)query;
- (void)postWithPath:(NSString *)path andQuery:(HttpQuery *)query andAttachments:(NSDictionary *) attachments;
- (HttpServiceResult *)mapServiceResultData:(id)httpServiceResultData;
- (void)enableSingleRequestMode;

+ (NSString *)getBaseUrl;
+ (void)setBaseUrl:(NSString *)baseUrl;
+ (void)sethasShowedNetworkAlert:(BOOL)hasAlert;

//added by wangweike 0906
- (void)postWithPath: (NSString *)path andQuery: (HttpQuery *)query constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;
@end
