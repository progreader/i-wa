//
//  MAddAlertDialogViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/14/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MAddAlertDialogViewController.h"
#import "Validator.h"

@interface MAddAlertDialogViewController ()<ValidatorDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation MAddAlertDialogViewController

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
    // Do any additional setup after loading the view from its nib.
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
    
    [validator putRule:[Rules minLength:1 withFailureString:@"标题不能为空!" forTextField:self.titleTextField]];
    [validator putRule:[Rules maxLength:14 withFailureString:@"标题不能多于14个字!" forTextField:self.titleTextField]];
    
    [validator validate];
}

#pragma ValidatorDelegate - Delegate methods

- (void) preValidation
{
    NSLog(@"Called before the validation begins");
}

- (void)onSuccess
{
    self.resultCode = 1;
    self.title = self.titleTextField.text;
    UIButton *button = [[UIButton alloc] init];
    button.tag = 2;
    [self closePopView:button];
}

- (void)onFailure:(Rule *)failedRule
{
    [SVProgressHUD showErrorWithStatus:failedRule.failureMessage];
    [failedRule.textField becomeFirstResponder];
}

@end
