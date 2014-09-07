//
//  ZApi.m
//  iRadio
//
//  Copyright (c) 2013 . All rights reserved.
//

#import "MApi.h"
#import "HttpServiceDelegate.h"

static NSString *CurrentAPIBaseURLString = @"http://203.195.166.239:8888";

@interface MApi()

@property (strong, nonatomic) NSObject<ServiceCallback> *callback;
@property (strong, nonatomic) NSString *sid;
@property (strong, nonatomic) HttpServiceDelegate *httpDelegate;

@end

@implementation MApi

- (id)init
{
    self = [super init];
    if (self) {
        self.httpDelegate = [[HttpServiceDelegate alloc]initWithUrlString:[MApi getBaseUrl]];
    }
    return self;
}

- (id)initWithSid:(NSString *)sid andCallback:(NSObject<ServiceCallback> *)callback
{
    self = [super init];
    if (self) {
        self.sid = sid;
        self.callback = callback;
        self.httpDelegate = [[HttpServiceDelegate alloc]initWithUrlString:[MApi getBaseUrl]];
    }
    return self;
}

- (id)initWithUrl:(NSString *)url sid:(NSString *)sid andCallback:(NSObject<ServiceCallback> *)callback
{
    self = [super init];
    if (self) {
        self.sid = sid;
        self.callback = callback;
        self.httpDelegate = [[HttpServiceDelegate alloc]initWithUrlString:url];
    }
    return self;
}

- (HttpQuery *)newQuery
{
    HttpQuery *query = [[HttpQuery alloc] init];
    return query;
}

- (void)getWithPath: (NSString *)path andQuery: (HttpQuery *)query
{
    [_httpDelegate getWithPath:path andQuery:query andCallback:self forSid:_sid];
}

- (void)postWithPath: (NSString *)path andQuery: (HttpQuery *)query
{
    [_httpDelegate postWithPath:path andQuery:query andCallback:self forSid:_sid];
}

- (void)putWithPath: (NSString *)path andQuery: (HttpQuery *)query andHttpHeader:(NSDictionary*)httpHeader
{
    [_httpDelegate putWithPath:path andQuery:query andCallback:self forSid:_sid forHttpHeader:httpHeader];
}

- (void)postWithPath: (NSString *)path andQuery: (HttpQuery *)query andAttachments: (NSDictionary *)attachments
{
    [_httpDelegate postWithPath:path andQuery:query andAttachments:attachments andCallback:self forSid:_sid];
}

- (void)postWithPath: (NSString *)path andQuery: (HttpQuery *)query constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    [_httpDelegate postWithPath:path andQuery:query constructingBodyWithBlock:block andCallback:self forSid:_sid];
}

static BOOL hasShowedNetworkAlert = NO;
+ (void)sethasShowedNetworkAlert:(BOOL)hasAlert
{
    hasShowedNetworkAlert = hasAlert;
}
- (void)responded:(HttpServiceResult *)result ofSid:(NSString *)sid
{
    ServiceResult *serviceResult = [[ServiceResult alloc]init];
    serviceResult.hasError = YES;
    if (0 == result.resultCode) {
        @try {
            serviceResult.data = [self mapServiceResultData:result.data];
            serviceResult.hasError = NO;
        } @catch (NSException *exception) {
            serviceResult.message = @"Reading data fail!";
        }
    } else  {
        serviceResult.message = result.message;
    }
    if (serviceResult.hasError) {
        if (1 == result.resultCode) {
            serviceResult.message = @"Connect fail, please check you network config!";
            if (!hasShowedNetworkAlert) {
                hasShowedNetworkAlert = YES;
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Connect fail!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                alert.alertViewStyle=UIAlertViewStyleDefault;
                [alert show];
            }
        } else if (2 == result.resultCode && nil != result.data) {
            if ([result.message isEqualToString:@"Request failed: bad gateway (502)"]) {
                if (!hasShowedNetworkAlert) {
                    hasShowedNetworkAlert = YES;
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Connect fail!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    alert.alertViewStyle=UIAlertViewStyleDefault;
                    [alert show];
                }
            }else{
                NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:[result.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                serviceResult.message = [returnDict valueForKey:@"message"];
            }
        } else if (4 == result.resultCode) {
            serviceResult.message = @"Reading data fail!";
        } else {
            serviceResult.message = @"Connect service fail, please try again!";
            if (!hasShowedNetworkAlert) {
                hasShowedNetworkAlert = YES;
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Connect fail!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                alert.alertViewStyle=UIAlertViewStyleDefault;
                [alert show];
            }
        }
        [SVProgressHUD dismiss];
        return;
    }
    [_callback callbackWithResult:serviceResult forSid:sid];
}

- (HttpServiceResult *)mapServiceResultData: (id)httpServiceResultData;
{
    return httpServiceResultData;
}

- (void)enableSingleRequestMode
{
    [_httpDelegate setMaxConcurrentOperationsCount:1];
}

+ (NSString *)getBaseUrl
{
    return CurrentAPIBaseURLString;
}

+ (void)setBaseUrl:(NSString *)baseUrl
{
    CurrentAPIBaseURLString = baseUrl;
}

@end

@implementation ServiceResult

@synthesize hasError = _hasError;
@synthesize errorCode, message, data;

@end
