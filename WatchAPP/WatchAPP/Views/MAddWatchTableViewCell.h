//
//  MAddWatchTableViewCell.h
//  WatchAPP
//
//  Created by Mike Mai on 6/29/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MAddWatchTableViewCellIdentifier = @"MAddWatchTableViewCell";

@interface MAddWatchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *imeiTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *phoneType1Button;
@property (weak, nonatomic) IBOutlet UIButton *phoneType2Button;

@end
