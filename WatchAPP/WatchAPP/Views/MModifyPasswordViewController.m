//
//  MModifyPasswordViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MModifyPasswordViewController.h"
#import "Validator.h"
#import "MOk2DialogViewController.h"
#import "MChangePasswordService.h"

@interface MModifyPasswordViewController ()<ValidatorDelegate, ServiceCallback>


@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *theNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPasswordTextField;
@property (strong, nonatomic) MChangePasswordService *changePasswordService;

@end

@implementation MModifyPasswordViewController

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
    self.changePasswordService = [[MChangePasswordService alloc] initWithSid:@"MChangePasswordService" andCallback:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnEnsureButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    Validator *validator = [[Validator alloc] init];
    validator.delegate   = self;
    
    [validator putRule:[Rules minLength:1 withFailureString:@"旧密码不能为空!" forTextField:self.oldPasswordTextField]];
    [validator putRule:[Rules minLength:1 withFailureString:@"新密码不能为空!" forTextField:self.theNewPasswordTextField]];
    [validator putRule:[Rules checkIfStringEquals:self.theNewPasswordTextField.text secondString:self.confirmNewPasswordTextField.text withFailureString:@"确认新要必须一致!" forTextField:self.confirmNewPasswordTextField]];
    
    [validator validate];
}

#pragma UITextFieldDelegate - Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (0 == textField.tag) {
        [self.theNewPasswordTextField becomeFirstResponder];
    } else if (1 == textField.tag) {
        [self.confirmNewPasswordTextField becomeFirstResponder];
    } else {
        [self.view endEditing:YES];

    }
    return YES;
}

#pragma ValidatorDelegate - Delegate methods

- (void) preValidation
{
    NSLog(@"Called before the validation begins");
}

- (void)onSuccess
{    
    [SVProgressHUD showWithMaskType:2];
    [self.changePasswordService requestChangePassword:self.oldPasswordTextField.text password:self.theNewPasswordTextField.text];
}

- (void)onFailure:(Rule *)failedRule
{
    [SVProgressHUD showErrorWithStatus:failedRule.failureMessage];
    [failedRule.textField becomeFirstResponder];
}

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    NSLog(@"%@", result.data);
    [SVProgressHUD dismiss];
    if ([sid isEqualToString:@"MChangePasswordService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            MOk2DialogViewController *viewController = [MOk2DialogViewController new];
            viewController.message = [NSString stringWithFormat:@"%@", @"修改成功！"];
            viewController.autoCloseCountDownSecond = 1.5;
            viewController.mj_dismissDelegate = self;
            [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                
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
