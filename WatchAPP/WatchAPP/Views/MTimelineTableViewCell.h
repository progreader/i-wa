//
//  MTimelineTableViewCell.h
//  WatchAPP
//
//  Created by Mike Mai on 6/30/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MTimelineTableViewCellIdentifier = @"MTimelineTableViewCell";

@interface MTimelineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *memeberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberCommentLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *supportButton;
@property (weak, nonatomic) IBOutlet UIButton *locusButton;
@property (weak, nonatomic) IBOutlet UIButton *memberImageButton;
@property (weak, nonatomic) IBOutlet UIButton *commentImageButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) UIViewController *replyViewController;

@end
