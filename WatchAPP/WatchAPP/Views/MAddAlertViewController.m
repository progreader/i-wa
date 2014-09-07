//
//  MAddAlertViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/2/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MAddAlertViewController.h"
#import "Validator.h"

@interface MAddAlertViewController ()<ValidatorDelegate>

@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MAddAlertViewController

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
    if ([self.alertDataItem[@"STATUS"] isEqualToString:@"ON"]) {
        [self.statusButton setImage:[UIImage imageNamed:@"打开按钮"] forState:UIControlStateNormal];
    } else {
        [self.statusButton setImage:[UIImage imageNamed:@"关闭按钮"] forState:UIControlStateNormal];
    }
    if ([self.alertDataItem[@"IS_NEW"] isEqualToString:@"NO"]) {
        self.titleLabel.text = @"编辑提醒";
    } else {
        self.titleLabel.text = @"新增提醒";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnStatusButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    BOOL isOn = YES;
    if ([self.alertDataItem[@"STATUS"] isEqualToString:@"ON"]) {
        isOn = NO;
        self.alertDataItem[@"STATUS"] = @"OFF";
    } else {
        self.alertDataItem[@"STATUS"] = @"ON";
    }
    if (isOn) {
        [self.statusButton setImage:[UIImage imageNamed:@"打开按钮"] forState:UIControlStateNormal];
    } else {
        [self.statusButton setImage:[UIImage imageNamed:@"关闭按钮"] forState:UIControlStateNormal];
    }
}

- (IBAction)didOnSaveButtonTapped:(id)sender
{
//    [self.view endEditing:YES];
//    Validator *validator = [[Validator alloc] init];
//    validator.delegate   = self;
//    
//    [validator putRule:[Rules minLength:1 withFailureString:@"标题不能为空!" forTextField:self.titleTextField]];
//    [validator validate];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITextFieldDelegate - Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (0 == textField.tag) {
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
//    self.alertDataItem[@"NAME"] = self.titleTextField.text;
    self.resultCode = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onFailure:(Rule *)failedRule
{
    [SVProgressHUD showErrorWithStatus:failedRule.failureMessage];
    [failedRule.textField becomeFirstResponder];
}

@end
