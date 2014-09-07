//
//  MChatMembersTableViewCell.h
//  WatchAPP
//
//  Created by Mike Mai on 6/30/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MChatMembersTableViewCellIdentifier = @"MChatMembersTableViewCell";

@interface MChatMembersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end
