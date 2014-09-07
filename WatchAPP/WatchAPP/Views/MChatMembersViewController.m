//
//  MChatMembersViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MChatMembersViewController.h"
#import "MChatMembersTableViewCell.h"
#import "MChatViewController.h"
#import "MMembersListService.h"
@interface MChatMembersViewController ()<ServiceCallback>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *memberDataItemList;
@property(strong,nonatomic) MMembersListService *membersListService;
@end

@implementation MChatMembersViewController

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

    [self.tableView registerNib:[UINib nibWithNibName:MChatMembersTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MChatMembersTableViewCellIdentifier];
    
    //谷少鹏 0906 通过服务获取家庭圈成员列表
    NSString * userID=[MAppDelegate sharedAppDelegate].loginData[@"obj"][@"_id"][@"$oid"];
    self.membersListService=[[MMembersListService alloc]initWithSid:@"MMembersListService" andCallback:self];
    [self.membersListService requestHomeMembersListByUserID:userID];
}
//谷少鹏 0905 调用后台服务回调 获取用户列表数据成功后更新tableview
- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    if ([sid isEqualToString:@"MMembersListService"]) {
        self.memberDataItemList = [[NSMutableArray alloc] init];
        NSMutableDictionary *memberDataItem = [[NSMutableDictionary alloc] init];
        [memberDataItem setObject:@"MEMBER" forKey:@"TYPE"];
        [memberDataItem setObject:@"***" forKey:@"IMEI"];
        [memberDataItem setObject:@"姐姐" forKey:@"NAME"];
        [memberDataItem setObject:@"" forKey:@"USERNAME"];
        [memberDataItem setObject:[NSString stringWithFormat:@"APP%d", 1] forKey:@"SHORT_NAME"];
        [memberDataItem setObject:@"" forKey:@"IMAGE_URL"];
        [self.memberDataItemList addObject: memberDataItem];
        
        memberDataItem = [[NSMutableDictionary alloc] init];
        [memberDataItem setObject:@"MEMBER" forKey:@"TYPE"];
        [memberDataItem setObject:@"***" forKey:@"IMEI"];
        [memberDataItem setObject:@"腕表-老爸" forKey:@"NAME"];
        [memberDataItem setObject:@"" forKey:@"USERNAME"];
        [memberDataItem setObject:[NSString stringWithFormat:@"APP%d", 1] forKey:@"SHORT_NAME"];
        [memberDataItem setObject:@"" forKey:@"IMAGE_URL"];
        [self.memberDataItemList addObject: memberDataItem];
        
        memberDataItem = [[NSMutableDictionary alloc] init];
        [memberDataItem setObject:@"MEMBER" forKey:@"TYPE"];
        [memberDataItem setObject:@"***" forKey:@"IMEI"];
        [memberDataItem setObject:@"群语音" forKey:@"NAME"];
        [memberDataItem setObject:@"" forKey:@"USERNAME"];
        [memberDataItem setObject:[NSString stringWithFormat:@"APP%d", 1] forKey:@"SHORT_NAME"];
        [memberDataItem setObject:@"" forKey:@"IMAGE_URL"];
        [self.memberDataItemList addObject: memberDataItem];
        
        [self.tableView reloadData];
        NSLog(@"%@", result.data);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.memberDataItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MChatMembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MChatMembersTableViewCellIdentifier];
    NSMutableDictionary *memberItem = [self.memberDataItemList objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", memberItem[@"NAME"]];
    
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
    NSMutableDictionary *memberDataItem = self.memberDataItemList[indexPath.row];
    MChatViewController *viewController = [MChatViewController new];
    viewController.allowsSendFace = NO;
    viewController.chatTitle = memberDataItem[@"NAME"];
    viewController.allowsPanToDismissKeyboard = NO;
    if (1 == indexPath.row || 2 == indexPath.row) {
        viewController.isOnlyAllowVoiceInput = YES;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
