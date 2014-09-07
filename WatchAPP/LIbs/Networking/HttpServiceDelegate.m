//
//  HttpServiceDelegate.m
//  
//
//  Copyright (c) 2013 . All rights reserved.
//

#import "HttpServiceDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "MXMLReader.h"

@interface HttpServiceDelegate ()

@end

@implementation HttpServiceDelegate

AFHTTPRequestOperationManager *httpClient;

- (id)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        NSURL *url = [NSURL URLWithString: self.urlString];
        httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        // FOR XML
//        [httpClient setResponseSerializer:[AFXMLParserResponseSerializer new]];
        // FOR JSON
        [httpClient setResponseSerializer:[AFJSONResponseSerializer new]];
        httpClient.operationQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

- (void)setMaxConcurrentOperationsCount:(int)count
{
    httpClient.operationQueue.maxConcurrentOperationCount = count;
}

- (void)getWithPath:(NSString *)path andQuery:(HttpQuery *)query andCallback:(NSObject<HttpServiceCallback> *)callback forSid:(NSString *)sid
{
    [httpClient GET:path parameters:query.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self success:sid callback:callback operation:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failure:error operation:operation sid:sid callback:callback];
    }];
}

- (void)postWithPath:(NSString *)path andQuery:(HttpQuery *)query andAttachments:(NSDictionary *)attachments andCallback:(NSObject<HttpServiceCallback>*) callback forSid:(NSString *) sid
{
    [httpClient POST:path parameters:query.parameters constructingBodyWithBlock:^(id formData) {
        if (attachments) {
            NSEnumerator *enumerator = [attachments keyEnumerator];
            id key;
            
            while ((key = [enumerator nextObject])) {
                NSData *fileData = [attachments valueForKey:key];
                
                //谷少鹏 0905 根据不同的文件类型进行不同的处理，要求key为带扩展名的文件名
                NSString *extension=[key pathExtension];
                if([extension isEqualToString:@"jpg"]){
                    [formData appendPartWithFileData:fileData name:@"avatar" fileName:key mimeType:@"image/jpeg"];
                }
                else if([extension isEqualToString:@"amr"]){
                    [formData appendPartWithFileData:fileData name:@"upfile" fileName:key mimeType:@"audio/amr"];
                }
            }
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self success:sid callback:callback operation:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failure:error operation:operation sid:sid callback:callback];
    }];
}

- (void)postWithPath:(NSString *)path andQuery:(HttpQuery *)query constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block andCallback:(NSObject<HttpServiceCallback>*)callback forSid:(NSString *)sid
{
    [httpClient POST:path parameters:query.parameters constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self success:sid callback:callback operation:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failure:error operation:operation sid:sid callback:callback];
    }];
}

- (void)postWithPath:(NSString *)path andQuery:(HttpQuery *)query andCallback:(NSObject<HttpServiceCallback> *)callback forSid:(NSString *)sid
{
    [httpClient POST:path parameters:query.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self success:sid callback:callback operation:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failure:error operation:operation sid:sid callback:callback];
    }];
}

- (void)putWithPath:(NSString *)path andQuery:(HttpQuery *)query andCallback:(NSObject<HttpServiceCallback> *)callback forSid:(NSString *)sid forHttpHeader:(NSDictionary*)httpHeader
{
    [httpClient PUT:path parameters:query.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self success:sid callback:callback operation:operation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failure:error operation:operation sid:sid callback:callback];
    }];
}

- (void)success:(NSString *)sid callback:(NSObject<HttpServiceCallback> *)callback operation:(AFHTTPRequestOperation *)operation
{
    HttpServiceResult *result = [[HttpServiceResult alloc] init];
    if (callback) {
        @try {
            if ([callback respondsToSelector:@selector(mapping:ofSid:)]) {
                result.data = [callback mapping: operation.responseString ofSid:sid];
            } else {
                //MLog(@"operation.responseString == %@", operation.responseString);
                // FOR XML
//                NSDictionary *returnDict = [MXMLReader dictionaryForXMLString:operation.responseString error:nil];
                // FOR JSON
                NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                result.data = returnDict;
            }
        } @catch (NSException *exception) {
            result.resultCode = DATA_ERROR;
        }
        [callback responded: result ofSid:sid];
    }
}

- (void)failure:(NSError *)error operation:(AFHTTPRequestOperation *)operation sid:(NSString *)sid callback:(NSObject<HttpServiceCallback> *)callback
{
    HttpServiceResult *result = [[HttpServiceResult alloc] init];
    NSString *errorString = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    result.message = errorString;
    if (nil == operation.responseString) {
        result.resultCode = CONNECTION_ERROR;
    } else {
        result.data = operation.responseString;
        result.resultCode = SERVER_ERROR;
    }
    if (callback) {
        [callback responded: result ofSid:sid];
    }
}

@end
