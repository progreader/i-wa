//
//  MTimelineReplyViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MTimelineReplyViewController.h"
#import "MTimelineCommentTableViewCell.h"

@interface MTimelineReplyViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *replyUsersLabel;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation MTimelineReplyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CALayer *layer = [self.containerView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:6.0];
    [layer setBorderWidth:0.0];
    [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:MTimelineCommentTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MTimelineCommentTableViewCellIdentifier];
    
    self.replyUsersLabel.text = self.replyUsers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replyItemDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTimelineCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MTimelineCommentTableViewCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
 
    NSMutableDictionary *replyItem = [self.replyItemDataList objectAtIndex:indexPath.row];
    
    [cell.replyUserLabel setText:[NSString stringWithFormat:@"%@: ", replyItem[@"REPLY_USER"]]];
    [cell.replyContentLabel setText:replyItem[@"REPLY_CONTENT"]];
    
    if ([replyItem[@"REPLY_CONTENT_TYPE"] isEqualToString:@"VOICE"]) {
        [cell.replyContentLabel setHidden:YES];
        [cell.voiceImage setHidden:NO];
        NSString *icon = replyItem[@"REPLY_CONTENT"];
        [cell.voiceImage setImage:[UIImage imageNamed:icon]];
    } else {
        [cell.replyContentLabel setHidden:NO];
        [cell.voiceImage setHidden:YES];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
