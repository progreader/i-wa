//
//  MAddWatchViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MAddWatchViewController.h"
#import "Validator.h"
#import "MAddWatchNickNameViewController.h"
#import "MAddWatchTableViewCell.h"
#import "MOk2DialogViewController.h"
#import "MActiveService.h"

@interface MAddWatchViewController ()<UITextFieldDelegate, ServiceCallback>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *watchDataItemList;
@property (strong, nonatomic) MActiveService *activeService;
@property (strong, nonatomic) NSString *deviceId;
@property (strong, nonatomic) NSString *simPhone;
@property (strong, nonatomic) NSString *simPhoneType;
@property (weak, nonatomic) IBOutlet UIButton *phoneType1Button;
@property (weak, nonatomic) IBOutlet UIButton *phoneType2Button;

@end

@implementation MAddWatchViewController

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
    viewFrame.size.height -= 64;
    self.view.frame = viewFrame;
    
    self.watchDataItemList = [[NSMutableArray alloc] init];
    NSMutableDictionary *watchDataItem = [[NSMutableDictionary alloc] init];
    [watchDataItem setObject:@"WATCH" forKey:@"TYPE"];
    [watchDataItem setObject:@"" forKey:@"IMEI"];
    [watchDataItem setObject:@"" forKey:@"NAME"];
    [watchDataItem setObject:@"" forKey:@"USER_NAME"];
    [watchDataItem setObject:@"" forKey:@"IMAGE_URL"];
    [watchDataItem setObject:@"" forKey:@"SIM_PHONE"];
    [watchDataItem setObject:@"unicom" forKey:@"SIM_PHONE_TYPE"];
    [watchDataItem setObject:[NSString stringWithFormat:@"腕表%d", self.watchDataItemList.count + 1] forKey:@"SHORT_NAME"];
    [self.watchDataItemList addObject:watchDataItem];
    
    self.simPhoneType = watchDataItem[@"SIM_PHONE_TYPE"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:MAddWatchTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MAddWatchTableViewCellIdentifier];
    
    self.activeService = [[MActiveService alloc] initWithSid:@"MActiveService" andCallback:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnBackHomeButtonTapped:(id)sender
{
    if (self.isInSetting) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        MOk2DialogViewController *viewController = [MOk2DialogViewController new];
        viewController.message = @"点击确定将开始体验，您可继续在设置栏添加腕表及成员。";
        viewController.mj_dismissDelegate = self;
        [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

- (IBAction)didOnAddWatchButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    NSMutableDictionary *watchDataItem = [[NSMutableDictionary alloc] init];
    [watchDataItem setObject:@"WATCH" forKey:@"TYPE"];
    [watchDataItem setObject:@"" forKey:@"IMEI"];
    [watchDataItem setObject:@"" forKey:@"NAME"];
    [watchDataItem setObject:@"" forKey:@"USERNAME"];
    [watchDataItem setObject:[NSString stringWithFormat:@"腕表%d", self.watchDataItemList.count + 1] forKey:@"SHORT_NAME"];
    [watchDataItem setObject:@"" forKey:@"IMAGE_URL"];
    [watchDataItem setObject:@"" forKey:@"SIM_PHONE"];
    [watchDataItem setObject:@"unicom" forKey:@"SIM_PHONE_TYPE"];
    [self.watchDataItemList addObject:watchDataItem];
    [self.tableView reloadData];
}

- (IBAction)didOnNextButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    for (int i = 0; i < self.watchDataItemList.count; i++) {
        NSMutableDictionary *watchDataItem = self.watchDataItemList[i];
        if ([NSString checkIfEmpty:watchDataItem[@"IMEI"]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            MAddWatchTableViewCell *cell = (MAddWatchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.imeiTextField becomeFirstResponder];
            [SVProgressHUD showErrorWithStatus:@"腕表串号不能为空!"];
            return;
        }
        
        if ([NSString checkIfEmpty:watchDataItem[@"SIM_PHONE"]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            MAddWatchTableViewCell *cell = (MAddWatchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.imeiTextField becomeFirstResponder];
            [SVProgressHUD showErrorWithStatus:@"电话号码不能为空!"];
            return;
        }
    }
    
     NSMutableDictionary *watchDataItem = self.watchDataItemList[0];
    self.deviceId = watchDataItem[@"IMEI"];
    self.simPhone = watchDataItem[@"SIM_PHONE"];

    [self.activeService requestActiveByDeviceId:self.deviceId simPhone:self.simPhone simPhoneType:self.simPhoneType];
}

- (void)didOnPhoneTypeButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    self.phoneType1Button.selected = NO;
    self.phoneType2Button.selected = NO;
    UIButton *button = sender;
    button.selected = YES;
    if (button.tag == 0) {
        self.simPhoneType = @"unicom";
    } else {
        self.simPhoneType = @"cmcc";
    }
}

#pragma UITextFieldDelegate - Delegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSMutableDictionary *watchDataItem = [self.watchDataItemList objectAtIndex:0];
    if (0 == textField.tag) {        
        watchDataItem[@"IMEI"] = textField.text;
    } else if (1 == textField.tag) {
        watchDataItem[@"SIM_PHONE"] = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag < self.watchDataItemList.count - 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag + 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        MAddWatchTableViewCell *cell = (MAddWatchTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.imeiTextField becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.watchDataItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAddWatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MAddWatchTableViewCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    cell.imeiTextField.tag = indexPath.row;
    cell.imeiTextField.delegate = self;
    
//    cell.phoneTextField.tag = indexPath.row;
    cell.phoneTextField.delegate = self;

    if (indexPath.row < self.watchDataItemList.count - 1) {
        [cell.imeiTextField setReturnKeyType:UIReturnKeyNext];
    } else {
        [cell.imeiTextField setReturnKeyType:UIReturnKeyDefault];
    }
    
    NSMutableDictionary *watchDataItem = [self.watchDataItemList objectAtIndex:indexPath.row];
    [cell.imeiTextField setText:watchDataItem[@"IMEI"]];
    [cell.phoneType1Button addTarget:self action:@selector(didOnPhoneTypeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.phoneType2Button addTarget:self action:@selector(didOnPhoneTypeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.phoneType1Button = cell.phoneType1Button;
    self.phoneType2Button = cell.phoneType2Button;
    
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

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    NSLog(@"%@", result.data);
    [SVProgressHUD dismiss];
    if ([sid isEqualToString:@"MActiveService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            [MAppDelegate sharedAppDelegate].deviceId = self.deviceId;
            
            MOk2DialogViewController *viewController = [MOk2DialogViewController new];
            viewController.message = @"请发送短信JH到腕表，或直接扫描二维码激活腕表。";
            viewController.mj_dismissDelegate = self;
            [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                MOk2DialogViewController *viewController = [MOk2DialogViewController new];
                viewController.message = @"正在激活腕表，请耐心等待。";
                viewController.mj_dismissDelegate = self;
                [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                    MAddWatchNickNameViewController *viewController = [MAddWatchNickNameViewController new];
                    viewController.watchDataItemList = self.watchDataItemList;
                    [self.navigationController pushViewController:viewController animated:YES];
                }];
                
            }];
            
        } else {
            MOk2DialogViewController *viewController = [MOk2DialogViewController new];
            viewController.message = [NSString stringWithFormat:@"%@", result.data[@"error_desc"]];
            viewController.autoCloseCountDownSecond = 1.5;
            viewController.mj_dismissDelegate = self;
            [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                
            }];
        }
    }
}

@end
