//
//  HttpQuery.m
//  
//
//  Copyright (c) 2013 . All rights reserved.
//

#import "HttpQuery.h"

@implementation HttpQuery

- (id)init
{
    self = [super init];
    if (self) {
        self.parameters = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addParam:(NSString *)param andValue:(id)value
{
    [self.parameters setValue:value forKey:param];
}

@end
