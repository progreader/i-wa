//
//  MPersonalInfoSettingViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MPersonalInfoSettingViewController.h"
#import "MPersonalInfoSettingTableViewCell.h"
#import "MModifyPasswordViewController.h"
#import "MAddMemberViewController.h"

@interface MPersonalInfoSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *personalInfoSettingItemList;

@end

@implementation MPersonalInfoSettingViewController

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
    
    self.personalInfoSettingItemList = [[NSMutableArray alloc] init];
    [self.personalInfoSettingItemList addObject:[NSDictionary dictionaryWithObjects:@[ @"头像昵称"] forKeys:@[ @"TITLE" ]]];
    [self.personalInfoSettingItemList addObject:[NSDictionary dictionaryWithObjects:@[ @"修改密码"] forKeys:@[ @"TITLE" ]]];

    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:MPersonalInfoSettingTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MPersonalInfoSettingTableViewCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.personalInfoSettingItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPersonalInfoSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MPersonalInfoSettingTableViewCellIdentifier];
    NSMutableDictionary *settingItem = [self.personalInfoSettingItemList objectAtIndex:indexPath.row];
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
        case 0:
        {
            MAddMemberViewController *viewController = [MAddMemberViewController new];
            viewController.isEditMode = YES;
            viewController.title = @"头像/昵称";
            NSMutableDictionary *memberDataItem = [[NSMutableDictionary alloc] init];
            [memberDataItem setObject:@"MEMBER" forKey:@"TYPE"];
            [memberDataItem setObject:@"***" forKey:@"IMEI"];
            [memberDataItem setObject:@"" forKey:@"NAME"];
            [memberDataItem setObject:@"" forKey:@"USERNAME"];
            [memberDataItem setObject:[NSString stringWithFormat:@"腕表%d", 2] forKey:@"SHORT_NAME"];
            [memberDataItem setObject:@"" forKey:@"IMAGE_URL"];
            viewController.memberDataItem = memberDataItem;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 1:
        {
            MModifyPasswordViewController *viewController = [MModifyPasswordViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
