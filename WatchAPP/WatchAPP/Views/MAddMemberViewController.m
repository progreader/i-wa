//
//  MAddMemberViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MAddMemberViewController.h"
#import "Validator.h"
#import "MPhotoPickerDialogViewController.h"

@interface MAddMemberViewController ()<ValidatorDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *imeiTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addHeaderButton;
@property (weak, nonatomic) IBOutlet UIButton *addOrConfirmButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MAddMemberViewController

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
    if (self.isEditMode) {
        [self.addOrConfirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [self.titleLabel setText:self.title];
    }
    
    [self.imeiTextLabel setText:[NSString stringWithFormat:@"%@ - %@", self.memberDataItem[@"SHORT_NAME"], self.memberDataItem[@"IMEI"]]];
    [self.nameTextField setText:self.memberDataItem[@"NAME"]];
    [self.usernameTextField setText:self.memberDataItem[@"USERNAME"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnAddButtonTapped:(id)sender
{
    [self validateAndAdd];
}

- (IBAction)didOnAddHeaderButtonTapped:(id)sender
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

- (void)validateAndAdd
{
    Validator *validator = [[Validator alloc] init];
    validator.delegate   = self;
    
    [validator putRule:[Rules minLength:1 withFailureString:@"名称不能为空!" forTextField:self.nameTextField]];
    [validator putRule:[Rules minLength:1 withFailureString:@"用户名不能为空!" forTextField:self.usernameTextField]];
    
    [validator validate];
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
    if (0 == textField.tag) {
        self.memberDataItem[@"NAME"] = textField.text;
    } else if (1 == textField.tag) {
        self.memberDataItem[@"USERNAME"] = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (0 == textField.tag) {
        [self.usernameTextField becomeFirstResponder];
    } else if (1 == textField.tag) {
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
    self.resultCode = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onFailure:(Rule *)failedRule
{
    [SVProgressHUD showErrorWithStatus:failedRule.failureMessage];
    [failedRule.textField becomeFirstResponder];
}

@end
