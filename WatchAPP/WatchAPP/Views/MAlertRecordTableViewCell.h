//
//  MAlertRecordTableViewCell.h
//  WatchAPP
//
//  Created by Mike Mai on 7/2/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MAlertRecordTableViewCellIdentifier = @"MAlertRecordTableViewCell";

@interface MAlertRecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *titleLabelCoverView;
@property (weak, nonatomic) IBOutlet UIView *timeLabelCoverView;
@property (weak, nonatomic) IBOutlet UIButton *coverButton;

@end
