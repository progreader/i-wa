//
//  MLocusBottomItemTableViewCell.h
//  WatchAPP
//
//  Created by Mike Mai on 7/2/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MLocusBottomItemTableViewCellIdentifier = @"MLocusBottomItemTableViewCell";

@interface MLocusBottomItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
