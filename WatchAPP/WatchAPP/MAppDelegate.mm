//
//  MAppDelegate.m
//  WatchAPP
//
//  Created by Mike Mai on 6/24/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MAppDelegate.h"
#import "MLoginViewController.h"
#import "MIntroductionViewController.h"
#import "IQKeyboardManager.h"

@implementation MAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 要使用百度地图，请先启动BaiduMapManager
	self.mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [self.mapManager start:@"5bx4A6a4lHu6Pcbca7adekaP" generalDelegate:self];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    self.homeViewController = [MHomeViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    [navigationController setNavigationBarHidden:YES];
    
//    NSString *key = (NSString *)kCFBundleVersionKey;
//    NSString *version = [NSBundle mainBundle].infoDictionary[key];
//    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    // Check Login
//    BOOL isLogined = NO;
//    id loginStatusObj = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_STATUS];
//    if (loginStatusObj) {
//        isLogined = [loginStatusObj boolValue];
//    }
//    if (![version isEqualToString:saveVersion]) {
//        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        MIntroductionViewController *introductionViewController = [MIntroductionViewController new];
//        [navigationController pushViewController:introductionViewController animated:NO];
//    } else if (!isLogined) {
//        MLoginViewController *loginViewController = [MLoginViewController new];
//        [navigationController pushViewController:loginViewController animated:NO];
//    }
    
//    MIntroductionViewController *introductionViewController = [MIntroductionViewController new];
    MLoginViewController *loginViewController = [MLoginViewController new];
//    [loginViewController addChildViewController:introductionViewController];
//    [loginViewController.view addSubview:introductionViewController.view];
//    loginViewController.isNeedToShowInstroductionView = YES;
    [navigationController pushViewController:loginViewController animated:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

+ (MAppDelegate *)sharedAppDelegate
{
    return (MAppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
