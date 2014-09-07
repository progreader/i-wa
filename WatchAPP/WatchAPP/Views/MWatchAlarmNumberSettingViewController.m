//
//  MWatchAlarmNumberSettingViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MWatchAlarmNumberSettingViewController.h"
#import "Validator.h"
#import "MOkOrCancelDialogViewController.h"
#import "MOk2DialogViewController.h"
#import "MEditPersonService.h"

@interface MWatchAlarmNumberSettingViewController ()<ValidatorDelegate, ServiceCallback>

@property (weak, nonatomic) IBOutlet UITextField *name1TextField;
@property (weak, nonatomic) IBOutlet UITextField *name2TextField;
@property (weak, nonatomic) IBOutlet UITextField *name3TextField;
@property (weak, nonatomic) IBOutlet UITextField *name4TextField;
@property (weak, nonatomic) IBOutlet UITextField *phone1TextField;
@property (weak, nonatomic) IBOutlet UITextField *phone2TextField;
@property (weak, nonatomic) IBOutlet UITextField *phone3TextField;
@property (weak, nonatomic) IBOutlet UITextField *phone4TextField;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) MEditPersonService *editPersonService;

@end

@implementation MWatchAlarmNumberSettingViewController

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
    if (self.isInSetting) {
        self.backButton.hidden = NO;
    } else {
        self.backButton.hidden = YES;
    }
    
    self.editPersonService = [[MEditPersonService alloc] initWithSid:@"MEditPersonService" andCallback:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnEnsureButtonTapped:(id)sender
{
    Validator *validator = [[Validator alloc] init];
    validator.delegate   = self;
    
//    [validator putRule:[Rules minLength:1 withFailureString:@"名称不能为空!" forTextField:self.name1TextField]];
    [validator putRule:[Rules minLength:1 withFailureString:@"手机号码不能为空!" forTextField:self.phone1TextField]];
//    [validator putRule:[Rules minLength:1 withFailureString:@"名称不能为空!" forTextField:self.name2TextField]];
    [validator putRule:[Rules minLength:1 withFailureString:@"手机号码不能为空!" forTextField:self.phone2TextField]];
//    [validator putRule:[Rules minLength:1 withFailureString:@"名称不能为空!" forTextField:self.name3TextField]];
    [validator putRule:[Rules minLength:1 withFailureString:@"手机号码不能为空!" forTextField:self.phone3TextField]];
//    [validator putRule:[Rules minLength:1 withFailureString:@"名称不能为空!" forTextField:self.name4TextField]];
    [validator putRule:[Rules minLength:1 withFailureString:@"手机号码不能为空!" forTextField:self.phone4TextField]];
    
    [validator validate];

}

#pragma UITextFieldDelegate - Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (0 == textField.tag) {
        [self.phone1TextField becomeFirstResponder];
    } else if (1 == textField.tag) {
        [self.name2TextField becomeFirstResponder];
    } else if (2 == textField.tag) {
        [self.phone2TextField becomeFirstResponder];
    } else if (3 == textField.tag) {
        [self.name3TextField becomeFirstResponder];
    } else if (4 == textField.tag) {
        [self.phone3TextField becomeFirstResponder];
    } else if (5 == textField.tag) {
        [self.name4TextField becomeFirstResponder];
    } else if(6 == textField.tag) {
        [self.phone4TextField becomeFirstResponder];
    } else if (7 == textField.tag) {
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
    
    NSDictionary *loginObj = [MAppDelegate sharedAppDelegate].loginData[@"obj"];
    NSString *personId = loginObj[@"_id"][@"$oid"];
    [self.editPersonService requestEditPersonByPersonId:personId sosNumber1:self.phone1TextField.text sosNumber2:self.phone2TextField.text sosNumber3:self.phone3TextField.text sosNumber4:self.phone4TextField.text];
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
    if ([sid isEqualToString:@"MEditPersonService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            if (self.isInSetting) {
                MOkOrCancelDialogViewController *viewController = [MOkOrCancelDialogViewController new];
                viewController.mj_dismissDelegate = self;
                viewController.message = @"是否确认号码修改或输入无误？";
                [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                    if (1 == viewController.resultCode) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            } else {
                MOk2DialogViewController *viewController = [MOk2DialogViewController new];
                viewController.message = @"恭喜完成腕表设置，点击确定马上体验，您可在家庭圈添加成员并分配帐号，让更多家庭成员关注老人健康。";
                viewController.mj_dismissDelegate = self;
                [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }
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
