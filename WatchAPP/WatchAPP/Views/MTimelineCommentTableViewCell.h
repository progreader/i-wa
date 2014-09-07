//
//  MTimelineCommentTableViewCell.h
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MTimelineCommentTableViewCellIdentifier = @"MTimelineCommentTableViewCell";

@interface MTimelineCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *replyUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;

@end
