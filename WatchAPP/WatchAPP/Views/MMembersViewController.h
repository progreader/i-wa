//
//  MMembersSettingViewController.h
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMembersViewController : MBaseViewController

@property (strong, nonatomic) NSMutableArray *memberDataItemList;
- (void)didOnAddMemberButtonTapped:(id)sender;

@end
