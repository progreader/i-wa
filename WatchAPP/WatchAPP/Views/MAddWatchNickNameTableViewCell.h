//
//  MAddWatchNickNameTableViewCell.h
//  WatchAPP
//
//  Created by Mike Mai on 6/29/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MAddWatchNickNameTableViewCellIdentifier = @"MAddWatchNickNameTableViewCell";

@interface MAddWatchNickNameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *imeiTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addHeaderButton;

@end
