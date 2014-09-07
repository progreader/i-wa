//
//  MRegisterViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MRegisterViewController.h"
#import "Validator.h"
#import "MOk2DialogViewController.h"
#import "MRegisterService.h"
#import "MMobileLoginService.h"
#import "MAddWatchViewController.h"

@interface MRegisterViewController ()<ValidatorDelegate, ServiceCallback>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) MRegisterService *registerService;
@property (strong, nonatomic) MMobileLoginService *mobileLoginService;

@end

@implementation MRegisterViewController

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
    
    self.registerService = [[MRegisterService alloc] initWithSid:@"MRegisterService" andCallback:self];
    self.mobileLoginService = [[MMobileLoginService alloc] initWithSid:@"MMobileLoginService" andCallback:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnRegisterButtonTapped:(id)sender
{
    Validator *validator = [[Validator alloc] init];
    validator.delegate   = self;
    
    [validator putRule:[Rules minLength:1 withFailureString:@"用户名不能为空!" forTextField:self.usernameTextField]];
    [validator putRule:[Rules minLength:1 withFailureString:@"email不能为空!" forTextField:self.emailTextField]];
    [validator putRule:[Rules minLength:1 withFailureString:@"密码不能为空!" forTextField:self.passwordTextField]];
    
    [validator validate];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (0 == textField.tag) {
        [self.passwordTextField becomeFirstResponder];
    } else if(1 == textField.tag) {
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
    [self.view endEditing:YES];
    [self.registerService requestRegisterByUsername:self.usernameTextField.text password:self.passwordTextField.text email:self.emailTextField.text];
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
    if ([sid isEqualToString:@"MRegisterService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            [self.mobileLoginService requestMobleLoginByUsername:self.usernameTextField.text password:self.passwordTextField.text];
        } else {
            MOk2DialogViewController *viewController = [MOk2DialogViewController new];
            viewController.message = [NSString stringWithFormat:@"%@", result.data[@"error_desc"]];
            viewController.autoCloseCountDownSecond = 1.5;
            viewController.mj_dismissDelegate = self;
            [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                
            }];
        }
    } else if ([sid isEqualToString:@"MMobileLoginService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            [MAppDelegate sharedAppDelegate].loginData = result.data;
            MOk2DialogViewController *viewController = [MOk2DialogViewController new];
            viewController.mj_dismissDelegate = self;
            viewController.message = [NSString stringWithFormat:@"恭喜您已被 %@ 添加为家庭成员，点击确定开始您的家庭健康之旅吧。", self.usernameTextField.text];
            [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
//                NSString *rule = result.data[@"obj"][@"rule"];
//                if ([rule isEqualToString:@"superuser"]) {
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                } else {
                    MAddWatchViewController *viewController = [MAddWatchViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
//                }
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
