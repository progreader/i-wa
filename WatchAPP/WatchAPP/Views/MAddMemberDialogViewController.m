//
//  MAddMemberDialogViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/29/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MAddMemberDialogViewController.h"

@interface MAddMemberDialogViewController ()

@end

@implementation MAddMemberDialogViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIButton *sender = [[UIButton alloc] init];
    sender.tag = 2;
    [self closePopView:sender];
}

- (IBAction)didOnAddWatchMemberButtonTapped:(id)sender
{
    self.resultCode = 1;
    [self closePopView:sender];
}

- (IBAction)didOnAddAppMemberButtonTapped:(id)sender
{
    self.resultCode = 2;
    [self closePopView:sender];
}

@end
