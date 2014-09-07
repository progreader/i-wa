//
//  MGalleyListTableViewCell.h
//  WatchAPP
//
//  Created by Mike Mai on 7/3/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MGalleyListTableViewCellIdentifier = @"MGalleyListTableViewCell";

@interface MGalleyListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *galleyImageView;

@end
