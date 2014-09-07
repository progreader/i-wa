//
//  MWorkStatusTableViewCell.h
//  WatchAPP
//
//  Created by Mike Mai on 14-8-28.
//  Copyright (c) 2014年 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MWorkStatusTableViewCellIdentifier = @"MWorkStatusTableViewCell";

@interface MWorkStatusTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *statusLabel;

@end
