//
//  MForgotViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MForgotViewController.h"
#import "MOk2DialogViewController.h"
#import "Validator.h"
#import "MRestPasswordService.h"

@interface MForgotViewController ()<ValidatorDelegate, ServiceCallback>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) MRestPasswordService *restPasswordService;

@end

@implementation MForgotViewController

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
    self.restPasswordService = [[MRestPasswordService alloc] initWithSid:@"MRestPasswordService" andCallback:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnSentEmailButtonTapped:(id)sender
{
    [self validateAndSendEmail];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (0 == textField.tag) {
        [self.view endEditing:YES];
    }
    return YES;
}

- (void)validateAndSendEmail
{
    Validator *validator = [[Validator alloc] init];
    validator.delegate   = self;
    
    [validator putRule:[Rules checkIsValidEmailWithFailureString:@"email格式不正确!" forTextField:self.emailTextField]];
    
    [validator validate];
}

#pragma ValidatorDelegate - Delegate methods

- (void) preValidation
{
    NSLog(@"Called before the validation begins");
}

- (void)onSuccess
{
    [self.view endEditing:YES];
    [self.restPasswordService requestResetPasswordByEmail:self.emailTextField.text];
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
    if ([sid isEqualToString:@"MRestPasswordService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            MOk2DialogViewController *viewController = [MOk2DialogViewController new];
            viewController.message = [NSString stringWithFormat:@"请登录 %@ 邮箱修改密码", self.emailTextField.text];
            viewController.mj_dismissDelegate = self;
            [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                [self.navigationController popViewControllerAnimated:YES];
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
