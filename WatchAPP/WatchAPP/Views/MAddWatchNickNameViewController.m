//
//  MAddWatchNickNameViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MAddWatchNickNameViewController.h"
#import "Validator.h"
#import "MWatchAlarmNumberSettingViewController.h"
#import "MPhotoPickerDialogViewController.h"
#import "MAddWatchNickNameTableViewCell.h"
#import "MOk2DialogViewController.h"

@interface MAddWatchNickNameViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MAddWatchNickNameViewController

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
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:MAddWatchNickNameTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MAddWatchNickNameTableViewCellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MOk2DialogViewController *viewController = [MOk2DialogViewController new];
    viewController.message = @"恭喜您，腕表绑定成功，以下资料还需进一步填写，为的是更加准确的分析家人健康。错误的资料会增加误判。";
    viewController.mj_dismissDelegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
       
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnNextButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    
    for (int i = 0; i < self.watchDataItemList.count; i++) {
        NSMutableDictionary *watchDataItem = self.watchDataItemList[i];
        if ([NSString checkIfEmpty:watchDataItem[@"NAME"]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            MAddWatchNickNameTableViewCell *cell = (MAddWatchNickNameTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.nameTextField becomeFirstResponder];
            [SVProgressHUD showErrorWithStatus:@"名称不能为空!"];
            return;
        }
        if ([NSString checkIfEmpty:watchDataItem[@"USERNAME"]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            MAddWatchNickNameTableViewCell *cell = (MAddWatchNickNameTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.usernameTextField becomeFirstResponder];
            [SVProgressHUD showErrorWithStatus:@"用户名不能为空!"];
            return;
        }
    }
    
    MWatchAlarmNumberSettingViewController *viewController = [MWatchAlarmNumberSettingViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didOnAddHeaderButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    MPhotoPickerDialogViewController *viewController = [MPhotoPickerDialogViewController new];
    viewController.mj_dismissDelegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:YES dismissed:^{
        switch (viewController.resultCode) {
            case 1:
            {
                [self takeThePhoto];
            }
                break;
            case 2:
            {
                [self pickThePhoto];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)takeThePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)pickThePhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma UITextFieldDelegate - Delegate methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag >= 1000) {
        NSMutableDictionary *watchDataItem = [self.watchDataItemList objectAtIndex:textField.tag - 1000];
        watchDataItem[@"USERNAME"] = textField.text;
    } else {
        NSMutableDictionary *watchDataItem = [self.watchDataItemList objectAtIndex:textField.tag];
        watchDataItem[@"NAME"] = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag >= 1000) {
        int tag = textField.tag - 1000;
        if (tag < self.watchDataItemList.count - 1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag + 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            MAddWatchNickNameTableViewCell *cell = (MAddWatchNickNameTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.nameTextField becomeFirstResponder];
        } else {
            [self.view endEditing:YES];
        }
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        MAddWatchNickNameTableViewCell *cell = (MAddWatchNickNameTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.usernameTextField becomeFirstResponder];
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
    MAddWatchNickNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MAddWatchNickNameTableViewCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.imeiTextLabel.tag = indexPath.row;
    cell.nameTextField.tag = indexPath.row;
    cell.nameTextField.delegate = self;
    cell.usernameTextField.tag = indexPath.row + 1000;
    cell.usernameTextField.delegate = self;
    cell.addHeaderButton.tag = indexPath.row;
    if (indexPath.row < self.watchDataItemList.count - 1) {
        [cell.usernameTextField setReturnKeyType:UIReturnKeyNext];
    } else {
        [cell.usernameTextField setReturnKeyType:UIReturnKeyDefault];
    }
    
    NSMutableDictionary *watchDataItem = [self.watchDataItemList objectAtIndex:indexPath.row];
    NSString *imeiString = [NSString stringWithFormat:@"%@: %@", watchDataItem[@"SHORT_NAME"], watchDataItem[@"IMEI"]];
    [cell.imeiTextLabel setText:imeiString];
    [cell.nameTextField setText:watchDataItem[@"NAME"]];
    [cell.usernameTextField setText:watchDataItem[@"USERNAME"]];
    [cell.addHeaderButton addTarget:self action:@selector(didOnAddHeaderButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
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

@end
