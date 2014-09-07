//
//  MHousekeeperSettingViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MHousekeeperSettingViewController.h"
#import "MHousekeeperSettingTableViewCell.h"
#import "MOkOrCancelDialogViewController.h"

@interface MHousekeeperSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *housekeeperSettingItemList;

@end

@implementation MHousekeeperSettingViewController

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
    self.housekeeperSettingItemList = [[NSMutableArray alloc] init];
    [self.housekeeperSettingItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"妹妹", @"NO"] forKeys:@[ @"NAME", @"IS_KEEPER"]]];
    [self.housekeeperSettingItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"自己", @"YES"] forKeys:@[ @"NAME", @"IS_KEEPER"]]];
    [self.housekeeperSettingItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"老妈", @"NO"] forKeys:@[ @"NAME", @"IS_KEEPER"]]];
    
    [self.tableView registerNib:[UINib nibWithNibName:MHousekeeperSettingTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MHousekeeperSettingTableViewCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.housekeeperSettingItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHousekeeperSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MHousekeeperSettingTableViewCellIdentifier];
    NSMutableDictionary *housekeeperSettingItem = [self.housekeeperSettingItemList objectAtIndex:indexPath.row];
    BOOL isKeeper = [housekeeperSettingItem[@"IS_KEEPER"] isEqualToString:@"YES"] ? YES : NO;
    [cell.nameLabel setText:isKeeper ? [NSString stringWithFormat:@"%@（管家）", housekeeperSettingItem[@"NAME"]] : housekeeperSettingItem[@"NAME"]];
    [cell.selectedImageView setHidden:!isKeeper];
    
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
    MOkOrCancelDialogViewController *viewController = [MOkOrCancelDialogViewController new];
    viewController.mj_dismissDelegate = self;
    viewController.message = @"是否设置当前人为管理员？";
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
        if (1 == viewController.resultCode) {
            for (NSMutableDictionary *housekeeperSettingItem in self.housekeeperSettingItemList) {
                housekeeperSettingItem[@"IS_KEEPER"] = @"NO";
            }
            NSMutableDictionary *housekeeperSettingItem = [self.housekeeperSettingItemList objectAtIndex:indexPath.row];
            housekeeperSettingItem[@"IS_KEEPER"] = @"YES";
            
            [self.tableView reloadData];
        }
    }];
}

@end
