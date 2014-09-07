//
//  MGalleyTableViewCell.h
//  WatchAPP
//
//  Created by Mike Mai on 7/3/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const MGalleyTableViewCellIdentifier = @"MGalleyTableViewCell";

@interface MGalleyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *galleyImageView;

@end
