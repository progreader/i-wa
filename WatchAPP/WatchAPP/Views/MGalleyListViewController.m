//
//  MGalleyListViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MGalleyListViewController.h"
#import "MGalleyListTableViewCell.h"
#import "MGalleyViewController.h"
#import "MSendMessageConfirmDialogViewController.h"
#import "MSendPictureViewController.h"
#import "MSendTextViewController.h"

@interface MGalleyListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *galleyDataItemList;


@end

@implementation MGalleyListViewController

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
    self.galleyDataItemList = [[NSMutableArray alloc] init];
    
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:MGalleyListTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MGalleyListTableViewCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGalleyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MGalleyListTableViewCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (0 == indexPath.row) {
//        [cell.dayLabel setHidden:YES];
//        [cell.monthLabel setHidden:YES];
//        [cell.contentLabel setHidden:YES];
        cell.monthTextLabel.text = @"8";
        [cell.galleyImageView setImage:[UIImage imageNamed:@"老公相册1"]];
    } else {
//        [cell.dayLabel setHidden:NO];
//        [cell.monthLabel setHidden:NO];
//        [cell.contentLabel setHidden:NO];
        cell.monthTextLabel.text = @"7";
        [cell.galleyImageView setImage:[UIImage imageNamed:@"老公相册2"]];
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
    MGalleyViewController *viewController = [MGalleyViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
