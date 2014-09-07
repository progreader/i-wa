//
//  MSettingListViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MSettingListViewController.h"
#import "MSettingTableViewCell.h"
#import "MWatchAlarmNumberSettingViewController.h"
#import "MHousekeeperSettingViewController.h"
#import "MMembersViewController.h"
#import "MPersonalInfoSettingViewController.h"
#import "JCRBlurView.h"

@interface MSettingListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (strong, nonatomic) NSMutableArray *settingItemList;

@end

@implementation MSettingListViewController

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
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= 50;
    self.view.frame = viewFrame;
    
    self.settingItemList = [[NSMutableArray alloc] init];
    [self.settingItemList addObject:[NSDictionary dictionaryWithObjects:@[ @"个人信息"] forKeys:@[ @"TITLE" ]]];
    [self.settingItemList addObject:[NSDictionary dictionaryWithObjects:@[ @"使用帮助"] forKeys:@[ @"TITLE" ]]];
    [self.settingItemList addObject:[NSDictionary dictionaryWithObjects:@[ @"关于版本"] forKeys:@[ @"TITLE" ]]];
    [self.settingItemList addObject:[NSDictionary dictionaryWithObjects:@[ @"为应用打分"] forKeys:@[ @"TITLE" ]]];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:MSettingTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MSettingTableViewCellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.headerContainerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settingItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MSettingTableViewCellIdentifier];
    NSMutableDictionary *settingItem = [self.settingItemList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", settingItem[@"TITLE"]];
    
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
    switch (indexPath.row) {
//        case 0:
//        {
//            MWatchAlarmNumberSettingViewController *viewController = [MWatchAlarmNumberSettingViewController new];
//            viewController.isInSetting = YES;
//            [self.navigationController pushViewController:viewController animated:YES];
//        }
//            break;
//        case 1:
//        {
//            MHousekeeperSettingViewController *viewController = [MHousekeeperSettingViewController new];
//            [self.navigationController pushViewController:viewController animated:YES];
//        }
//            break;
//        case 2:
//        {
//            MMembersSettingViewController *viewController = [MMembersSettingViewController new];
//            viewController.isInSetting = YES;
//            viewController.memberDataItemList = [[NSMutableArray alloc] init];
//            NSMutableDictionary *watchDataItem = [[NSMutableDictionary alloc] init];
//            [watchDataItem setObject:@"WATCH" forKey:@"TYPE"];
//            [watchDataItem setObject:@"" forKey:@"IMEI"];
//            [watchDataItem setObject:@"姐姐" forKey:@"NAME"];
//            [watchDataItem setObject:@"" forKey:@"USER_NAME"];
//            [watchDataItem setObject:@"" forKey:@"IMAGE_URL"];
//            [watchDataItem setObject:[NSString stringWithFormat:@"腕表%d", 1] forKey:@"SHORT_NAME"];
//            [viewController.memberDataItemList addObject:watchDataItem];
//            [self.navigationController pushViewController:viewController animated:YES];
//        }
//            break;
        case 0:
        {
            MPersonalInfoSettingViewController *viewController = [MPersonalInfoSettingViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
