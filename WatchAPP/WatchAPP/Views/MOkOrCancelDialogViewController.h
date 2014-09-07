//
//  MOkOrCancelDialogViewController.h
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOkOrCancelDialogViewController : MBaseDialogViewController

@property (nonatomic) int resultCode;
@property (strong, nonatomic) NSString *message;

@end
