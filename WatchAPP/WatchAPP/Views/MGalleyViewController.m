//
//  MGalleyViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MGalleyViewController.h"
#import "MOk2DialogViewController.h"
#import "MGalleyTableViewCell.h"
#import "MGalleyPictureViewController.h"

@interface MGalleyViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *galleyDataItemList;

@end

@implementation MGalleyViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:MGalleyTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MGalleyTableViewCellIdentifier];
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
    MGalleyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MGalleyTableViewCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (0 == indexPath.row) {
        [cell.galleyImageView setImage:[UIImage imageNamed:@"老公相册1"]];
    } else {
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
    MGalleyPictureViewController *viewController = [MGalleyPictureViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
