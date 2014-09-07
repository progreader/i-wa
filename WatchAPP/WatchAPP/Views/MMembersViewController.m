//
//  MMembersSettingViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MMembersViewController.h"
#import "Validator.h"
#import "MAddMemberViewController.h"
#import "MWatchAlarmNumberSettingViewController.h"
#import "MMembersTableViewCell.h"
#import "MAddWatchViewController.h"

@interface MMembersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MAddMemberViewController *addMemberViewController;
@property (nonatomic) BOOL isModifying;

@end

@implementation MMembersViewController

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

    [self.tableView registerNib:[UINib nibWithNibName:MMembersTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MMembersTableViewCellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isModifying && nil != self.addMemberViewController) {
        self.isModifying = NO;
        if (1 == self.addMemberViewController.resultCode && !self.addMemberViewController.isEditMode) {
            [self.memberDataItemList addObject:self.addMemberViewController.memberDataItem];
        }
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didOnAddMemberButtonTapped:(id)sender
{
    UIButton *button = sender;
    switch (button.tag) {
        case 1:
        {
            MAddWatchViewController *viewController = [MAddWatchViewController new];
            viewController.isInSetting = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 2:
        {
            self.addMemberViewController = [MAddMemberViewController new];
            int memberCount = 0;
            for (NSMutableDictionary *tempItem in self.memberDataItemList) {
                if ([tempItem[@"TYPE"] isEqualToString:@"MEMBER"]) {
                    memberCount += 1;
                }
            }
            NSMutableDictionary *memberDataItem = [[NSMutableDictionary alloc] init];
            [memberDataItem setObject:@"MEMBER" forKey:@"TYPE"];
            [memberDataItem setObject:@"***" forKey:@"IMEI"];
            [memberDataItem setObject:@"" forKey:@"NAME"];
            [memberDataItem setObject:@"" forKey:@"USERNAME"];
            [memberDataItem setObject:[NSString stringWithFormat:@"APP%d", memberCount + 1] forKey:@"SHORT_NAME"];
            [memberDataItem setObject:@"" forKey:@"IMAGE_URL"];
            self.addMemberViewController.memberDataItem = memberDataItem;
            self.addMemberViewController.title = @"新成员";
            [self.navigationController pushViewController:self.addMemberViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.memberDataItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MMembersTableViewCellIdentifier];
    NSMutableDictionary *memberDataItem = [self.memberDataItemList objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ - %@", memberDataItem[@"SHORT_NAME"], memberDataItem[@"NAME"]];
    
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
    self.isModifying = YES;
    self.addMemberViewController = [MAddMemberViewController new];
    self.addMemberViewController.isEditMode = YES;
    self.addMemberViewController.title = @"编辑信息";
    NSMutableDictionary *memberDataItem = [self.memberDataItemList objectAtIndex:indexPath.row];
    self.addMemberViewController.memberDataItem = memberDataItem;
    
    [self.navigationController pushViewController:self.addMemberViewController animated:YES];
}

@end
