//
//  MAppDelegate.h
//  WatchAPP
//
//  Created by Mike Mai on 6/24/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MHomeViewController.h"

@interface MAppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BMKMapManager *mapManager;
@property (strong, nonatomic) MHomeViewController *homeViewController;

@property (strong, nonatomic) NSDictionary *loginData;
@property (strong, nonatomic) NSString *deviceId;

+ (MAppDelegate *)sharedAppDelegate;

@end
