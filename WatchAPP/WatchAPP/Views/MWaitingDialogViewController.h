//
//  MOkDialogViewController.h
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWaitingDialogViewController : MBaseDialogViewController

@property (strong, nonatomic) NSString *message;
@property (nonatomic) int autoCloseCountDownSecond;

-(void)setWaitingMessage:(NSString *)message;

@end
