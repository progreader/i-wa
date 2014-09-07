//
//  MLoginViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MLoginViewController.h"
#import "MForgotViewController.h"
#import "MRegisterViewController.h"
#import "MAddWatchViewController.h"
#import "Validator.h"
#import "MMobileLoginService.h"
#import "MOk2DialogViewController.h"

@interface MLoginViewController ()<ValidatorDelegate, ServiceCallback>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *motion1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *motion2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *motion3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *motion4ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *motion5ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *motion13dImageView;
@property (weak, nonatomic) IBOutlet UIImageView *motion23dImageView;
@property (weak, nonatomic) IBOutlet UIImageView *motion33dImageView;
@property (weak, nonatomic) IBOutlet UIImageView *motion43dImageView;
@property (weak, nonatomic) IBOutlet UIImageView *motion53dImageView;
@property (weak, nonatomic) IBOutlet UILabel *motionLabel;
@property (strong, nonatomic) MMobileLoginService *mobileLoginService;

@end

@implementation MLoginViewController

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
    
    self.mobileLoginService = [[MMobileLoginService alloc] initWithSid:@"MMobileLoginService" andCallback:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.isNeedToShowInstroductionView) {
       [self startMotion];
    }
}

- (void)startMotion
{
    CGRect motion13dImageViewFrame = self.motion13dImageView.frame;
    motion13dImageViewFrame.origin.x = 320;
    motion13dImageViewFrame.origin.y = 97;
    self.motion13dImageView.frame = motion13dImageViewFrame;
    [self.motion13dImageView setHidden:NO];
    
    CGRect motion23dImageViewFrame = self.motion23dImageView.frame;
    motion23dImageViewFrame.origin.x = 320;
    motion23dImageViewFrame.origin.y = 40;
    self.motion23dImageView.frame = motion23dImageViewFrame;
    [self.motion23dImageView setHidden:NO];
    
    CGRect motion33dImageViewFrame = self.motion33dImageView.frame;
    motion33dImageViewFrame.origin.x = 320;
    motion33dImageViewFrame.origin.y = 0;
    self.motion33dImageView.frame = motion33dImageViewFrame;
    [self.motion33dImageView setHidden:NO];
    
    CGRect motion43dImageViewFrame = self.motion43dImageView.frame;
    motion43dImageViewFrame.origin.x = 320;
    motion43dImageViewFrame.origin.y = 41;
    self.motion43dImageView.frame = motion43dImageViewFrame;
    [self.motion43dImageView setHidden:NO];
    
    CGRect motion53dImageViewFrame = self.motion53dImageView.frame;
    motion53dImageViewFrame.origin.x = 320;
    motion53dImageViewFrame.origin.y = 97;
    self.motion53dImageView.frame = motion53dImageViewFrame;
    [self.motion53dImageView setHidden:NO];
    
    [self.motion1ImageView setHidden:YES];
    [self.motion2ImageView setHidden:YES];
    [self.motion3ImageView setHidden:YES];
    [self.motion4ImageView setHidden:YES];
    [self.motion5ImageView setHidden:YES];
    // 动画1
    self.motionLabel.alpha = 0;
    self.motionLabel.text = @"太太可以监护全家健康";
    [UIView animateWithDuration:2.0 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect motion13dImageViewFrame2 = self.motion13dImageView.frame;
        motion13dImageViewFrame2.origin.x = 184;
        self.motion13dImageView.frame = motion13dImageViewFrame2;
        self.motionLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [self.motion1ImageView setHidden:NO];
        [UIView animateWithDuration:2.0 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.motionLabel.alpha = 0;
        } completion:^(BOOL finished) {
            // 动画2 老人
            self.motionLabel.text = @"时刻知道老人的心率";
            
            [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect motion23dImageViewFrame2 = self.motion23dImageView.frame;
                motion23dImageViewFrame2.origin.x = 280;
                self.motion23dImageView.frame = motion23dImageViewFrame2;
                self.motionLabel.alpha = 0.5;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGRect motion23dImageViewFrame2 = self.motion23dImageView.frame;
                    motion23dImageViewFrame2.origin.x = 270;
                    self.motion23dImageView.frame = motion23dImageViewFrame2;
                    self.motionLabel.alpha = 1.0;
                    self.motion23dImageView.transform = CGAffineTransformMakeRotation((360 - 180)  / 180.0 * M_PI );
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                        CGRect motion23dImageViewFrame2 = self.motion23dImageView.frame;
                        motion23dImageViewFrame2.origin.x = 260;
                        self.motion23dImageView.frame = motion23dImageViewFrame2;
                        self.motionLabel.alpha = 1.0;
                        self.motion23dImageView.transform = CGAffineTransformMakeRotation((360 - 359) / 180.0 * M_PI );
                    } completion:^(BOOL finished) {
                        self.motion23dImageView.transform = CGAffineTransformMakeRotation(0);
                        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                            CGRect motion23dImageViewFrame2 = self.motion23dImageView.frame;
                            motion23dImageViewFrame2.origin.x = 250;
                            self.motion23dImageView.frame = motion23dImageViewFrame2;
                            self.motionLabel.alpha = 1.0;
                            self.motion23dImageView.transform = CGAffineTransformMakeRotation((360 - 180)  / 180.0 * M_PI );
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                                CGRect motion23dImageViewFrame2 = self.motion23dImageView.frame;
                                motion23dImageViewFrame2.origin.x = 240;
                                self.motion23dImageView.frame = motion23dImageViewFrame2;
                                self.motionLabel.alpha = 1.0;
                                self.motion23dImageView.transform = CGAffineTransformMakeRotation((360 - 359)  / 180.0 * M_PI );
                            } completion:^(BOOL finished) {
                                self.motion23dImageView.transform = CGAffineTransformMakeRotation(0);
                                [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                                    CGRect motion23dImageViewFrame2 = self.motion23dImageView.frame;
                                    motion23dImageViewFrame2.origin.x = 201;
                                    self.motion23dImageView.frame = motion23dImageViewFrame2;
                                    self.motionLabel.alpha = 1;
                                } completion:^(BOOL finished) {
                                    [self doMotion3];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (void)doMotion3
{
    [self.motion2ImageView setHidden:NO];
    [UIView animateWithDuration:2.0 delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.motionLabel.alpha = 0;
    } completion:^(BOOL finished) {
        // 动画3 老人2
        self.motionLabel.text = @"手机端随时关怀老人";
        [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect motion33dImageViewFrame2 = self.motion33dImageView.frame;
            motion33dImageViewFrame2.origin.x = 280;
            self.motion33dImageView.frame = motion33dImageViewFrame2;
            self.motionLabel.alpha = 0.5;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect motion33dImageViewFrame2 = self.motion33dImageView.frame;
                motion33dImageViewFrame2.origin.x = 260;
                self.motion33dImageView.frame = motion33dImageViewFrame2;
                self.motionLabel.alpha = 1;
                self.motion33dImageView.transform = CGAffineTransformMakeRotation((360 - 180)  / 180.0 * M_PI);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGRect motion33dImageViewFrame2 = self.motion33dImageView.frame;
                    motion33dImageViewFrame2.origin.x = 240;
                    self.motion33dImageView.frame = motion33dImageViewFrame2;
                    self.motionLabel.alpha = 1;
                    self.motion33dImageView.transform = CGAffineTransformMakeRotation((360 - 359)  / 180.0 * M_PI);
                } completion:^(BOOL finished) {
                    self.motion33dImageView.transform = CGAffineTransformMakeRotation(0);
                    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                        CGRect motion33dImageViewFrame2 = self.motion33dImageView.frame;
                        motion33dImageViewFrame2.origin.x = 220;
                        self.motion33dImageView.frame = motion33dImageViewFrame2;
                        self.motionLabel.alpha = 1;
                        self.motion33dImageView.transform = CGAffineTransformMakeRotation((360 - 180)  / 180.0 * M_PI);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                            CGRect motion33dImageViewFrame2 = self.motion33dImageView.frame;
                            motion33dImageViewFrame2.origin.x = 200;
                            self.motion33dImageView.frame = motion33dImageViewFrame2;
                            self.motionLabel.alpha = 1;
                            self.motion33dImageView.transform = CGAffineTransformMakeRotation((360 - 359)  / 180.0 * M_PI);
                        } completion:^(BOOL finished) {
                            self.motion33dImageView.transform = CGAffineTransformMakeRotation(0);
                            [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                                CGRect motion33dImageViewFrame2 = self.motion33dImageView.frame;
                                motion33dImageViewFrame2.origin.x = 141;
                                self.motion33dImageView.frame = motion33dImageViewFrame2;
                                self.motionLabel.alpha = 1;
                            } completion:^(BOOL finished) {
                                [self doMotion4];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (void)doMotion4
{
    [self.motion3ImageView setHidden:NO];
    [UIView animateWithDuration:2.0 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.motionLabel.alpha = 0;
    } completion:^(BOOL finished) {
        // 动画4
        self.motionLabel.text = @"家人健康他也知道";
        [UIView animateWithDuration:2.0 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect motion43dImageViewFrame2 = self.motion43dImageView.frame;
            motion43dImageViewFrame2.origin.x = 81;
            self.motion43dImageView.frame = motion43dImageViewFrame2;
            self.motionLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [self.motion4ImageView setHidden:NO];
            [UIView animateWithDuration:2.0 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.motionLabel.alpha = 0;
            } completion:^(BOOL finished) {
                // 动画5 小孩
                self.motionLabel.text = @"小孩到校一查便知";
                [UIView animateWithDuration:0.4 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGRect motion53dImageViewFrame2 = self.motion53dImageView.frame;
                    motion53dImageViewFrame2.origin.x = 280;
                    self.motion53dImageView.frame = motion53dImageViewFrame2;
                    self.motionLabel.alpha = 1;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                        CGRect motion53dImageViewFrame2 = self.motion53dImageView.frame;
                        motion53dImageViewFrame2.origin.x = 255;
                        self.motion53dImageView.frame = motion53dImageViewFrame2;
                        self.motionLabel.alpha = 1;
                        self.motion53dImageView.transform = CGAffineTransformMakeRotation((360 - 180)  / 180.0 * M_PI);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                            CGRect motion53dImageViewFrame2 = self.motion53dImageView.frame;
                            motion53dImageViewFrame2.origin.x = 230;
                            self.motion53dImageView.frame = motion53dImageViewFrame2;
                            self.motionLabel.alpha = 1;
                            self.motion53dImageView.transform = CGAffineTransformMakeRotation((360 - 359)  / 180.0 * M_PI);
                        } completion:^(BOOL finished) {
                            self.motion53dImageView.transform = CGAffineTransformMakeRotation(0);
                            [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                                CGRect motion53dImageViewFrame2 = self.motion53dImageView.frame;
                                motion53dImageViewFrame2.origin.x = 205;
                                self.motion53dImageView.frame = motion53dImageViewFrame2;
                                self.motionLabel.alpha = 1;
                                self.motion53dImageView.transform = CGAffineTransformMakeRotation((360 - 180)  / 180.0 * M_PI);
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                                    CGRect motion53dImageViewFrame2 = self.motion53dImageView.frame;
                                    motion53dImageViewFrame2.origin.x = 184;
                                    self.motion53dImageView.frame = motion53dImageViewFrame2;
                                    self.motionLabel.alpha = 1;
                                    self.motion53dImageView.transform = CGAffineTransformMakeRotation((360 - 359)  / 180.0 * M_PI);
                                } completion:^(BOOL finished) {
                                    self.motion53dImageView.transform = CGAffineTransformMakeRotation(0);
                                    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                                        CGRect motion53dImageViewFrame2 = self.motion53dImageView.frame;
                                        motion53dImageViewFrame2.origin.x = 145;
                                        motion53dImageViewFrame2.origin.y = 57;
                                        self.motion53dImageView.frame = motion53dImageViewFrame2;
                                        self.motionLabel.alpha = 1;
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                                            CGRect motion53dImageViewFrame2 = self.motion53dImageView.frame;
                                            motion53dImageViewFrame2.origin.x = 106;
                                            motion53dImageViewFrame2.origin.y = 97;
                                            self.motion53dImageView.frame = motion53dImageViewFrame2;
                                            self.motionLabel.alpha = 1;
                                        } completion:^(BOOL finished) {
                                            [self.motion5ImageView setHidden:NO];
                                            [UIView animateWithDuration:2.0 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                self.motionLabel.alpha = 0;
                                            } completion:^(BOOL finished) {
                                                self.motionLabel.text = @"";
                                            }];
                                        }];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnLoginButtonTapped:(id)sender
{
    Validator *validator = [[Validator alloc] init];
    validator.delegate   = self;
    
    [validator putRule:[Rules minLength:1 withFailureString:@"用户名不能为空!" forTextField:self.usernameTextField]];
    [validator putRule:[Rules minLength:1 withFailureString:@"密码不能为空!" forTextField:self.passwordTextField]];
    
    [validator validate];
}

- (IBAction)didOnForgotPasswordButtonTapped:(id)sender
{
    MForgotViewController *viewController = [MForgotViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)didOnRegisterButtonTapped:(id)sender
{
    MRegisterViewController *viewController = [MRegisterViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
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
    [self.mobileLoginService requestMobleLoginByUsername:self.usernameTextField.text password:self.passwordTextField.text];
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
    if ([sid isEqualToString:@"MMobileLoginService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            [MAppDelegate sharedAppDelegate].loginData = result.data;
            NSDictionary *loginObj = result.data[@"obj"];
            [MAppDelegate sharedAppDelegate].deviceId = loginObj[@"device"];

            // TODO 处理登录逻辑
//            NSString *rule = result.data[@"obj"][@"rule"];
//            if ([rule isEqualToString:@"superuser"]) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            } else {
                MAddWatchViewController *viewController = [MAddWatchViewController new];
                [self.navigationController pushViewController:viewController animated:YES];
//            }
            
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
