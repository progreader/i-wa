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
#import "UIImageView+WebCache.h"
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
   
    NSString *groupId= [MAppDelegate sharedAppDelegate].loginData[@"obj"][@"$group"][@"_id"][@"$oid"];
    //谷少鹏 0906 通过服务获取家庭圈成员列表
    self.membersListService=[[MMembersListService alloc]initWithSid:@"MMembersListService" andCallback:self];
    
    [self.membersListService requestGroupInfoById:groupId];
//    [self.membersListService requestHomeInfo];
}

//谷少鹏 0905 调用后台服务回调 获取用户列表数据成功后更新tableview
- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    if ([sid isEqualToString:@"MMembersListService"]) {
       
        NSString *groupID= [MAppDelegate sharedAppDelegate].loginData[@"obj"][@"$group"][@"_id"][@"$oid"];
        NSString *loginOID=[MAppDelegate sharedAppDelegate].loginData[@"obj"][@"_id"][@"$oid"];
        NSString *groupName=@"群语音";
        NSArray *members=result.data[@"obj"][@"members"];
        
        self.memberDataItemList = [[NSMutableArray alloc] init];
        for(int i=0;i<members.count;i++){
            NSDictionary *member=members[i][@"$person"];
            NSString *memberID=member[@"_id"][@"$oid"];
            if([memberID isEqualToString:loginOID]) continue;
            NSString *memberName=member[@"nickname"];
            NSString *avatarUrl=[[MMembersListService getBaseUrl] stringByAppendingString:member[@"avatar_url"]];
            
            NSMutableDictionary *memberDataItem = [[NSMutableDictionary alloc] init];
            [memberDataItem setObject:@"MEMBER" forKey:@"TYPE"];
            [memberDataItem setObject:memberID forKey:@"OID"];
            [memberDataItem setObject:memberName forKey:@"NAME"];
            [memberDataItem setObject:avatarUrl forKey:@"IMAGE_URL"];
            [self.memberDataItemList addObject: memberDataItem];
        }
        NSMutableDictionary *groupDataItem = [[NSMutableDictionary alloc] init];
        [groupDataItem setObject:@"GROUP" forKey:@"TYPE"];
        [groupDataItem setObject:groupID forKey:@"OID"];
        [groupDataItem setObject:groupName forKey:@"NAME"];
        [groupDataItem setObject:@"home.png" forKey:@"IMAGE_URL"];
        
        [self.memberDataItemList addObject: groupDataItem];

        [self.tableView reloadData];
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
    NSString *imageURL=memberItem[@"IMAGE_URL"];
    if([memberItem[@"TYPE"] isEqualToString:@"MEMBER"]){
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    }
    else if([memberItem[@"TYPE"] isEqualToString:@"GROUP"]){
        [cell.headerImageView setImage:[UIImage imageNamed:imageURL]];
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
    NSMutableDictionary *memberDataItem = self.memberDataItemList[indexPath.row];
    MChatViewController *viewController = [MChatViewController new];
    viewController.memberDataItem=memberDataItem;
    viewController.allowsSendFace = NO;
    viewController.chatTitle = memberDataItem[@"NAME"];
    viewController.allowsPanToDismissKeyboard = NO;
 
//谷少鹏 0906 所有情况下均为只允许发送语音
//    if (1 == indexPath.row || 2 == indexPath.row) {
//        viewController.isOnlyAllowVoiceInput = YES;
//    }
     viewController.isOnlyAllowVoiceInput=YES;
    
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
