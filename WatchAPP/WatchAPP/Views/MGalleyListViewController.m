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
#import "MMembersListService.h"
#import "UIImageView+WebCache.h"

@interface MGalleyListViewController ()<ServiceCallback>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *galleyDataItemList;

@property(strong,nonatomic) MMembersListService *membersListService;
@property (strong, nonatomic) id members;

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
    
    id loginData=[MAppDelegate sharedAppDelegate].loginData;
    //self.members=loginData[@"$group"][@"members"];
    
    NSString * groupId=loginData[@"obj"][@"group"][@"$oid"];
    self.membersListService=[[MMembersListService alloc]initWithSid:@"MMembersListService" andCallback:self];
    [self.membersListService requestHomeMembersListByUserID:groupId];
}

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    BOOL success=[result.data[@"success"] intValue]==1;
    if(success)
    {
        self.members=result.data[@"obj"][@"members"];
        
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
    return [self.members count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGalleyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MGalleyListTableViewCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    id memberdata=self.members[indexPath.row];
    id membername=memberdata[@"member_name"];
    id iconUrl=memberdata[@"$person"][@"avatar_url"];
    
    cell.monthTextLabel.text = membername;
    [cell.galleyImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl relativeToURL:[NSURL URLWithString:[MApi getBaseUrl]]]];
    
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
    id memberdata=self.members[indexPath.row];
    id membername=memberdata[@"member_name"];
    id iconUrl=memberdata[@"$person"][@"avatar_url"];
    
    MGalleyViewController *viewController = [MGalleyViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
