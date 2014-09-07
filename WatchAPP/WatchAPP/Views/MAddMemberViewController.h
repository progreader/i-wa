//
//  MAddMemberViewController.h
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAddMemberViewController : MBaseViewController

@property (strong, nonatomic) NSMutableDictionary *memberDataItem;
@property (nonatomic) int resultCode;
@property (nonatomic) int isEditMode;
@property (strong, nonatomic) NSString *title;

@end
