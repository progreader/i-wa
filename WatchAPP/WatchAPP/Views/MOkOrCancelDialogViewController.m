//
//  MOkOrCancelDialogViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MOkOrCancelDialogViewController.h"

@interface MOkOrCancelDialogViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation MOkOrCancelDialogViewController

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
    [self.messageLabel setText:self.message];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnEnsureButtonTapped:(id)sender
{
    self.resultCode = 1;
    [self closePopView:sender];
}

@end
