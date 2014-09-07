//
//  MSavePictureDialogViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/3/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MSavePictureDialogViewController.h"

@interface MSavePictureDialogViewController ()

@end

@implementation MSavePictureDialogViewController

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

- (IBAction)didOnSaveSuccessButtonTapped:(id)sender
{
    [self closePopView:sender];
}

@end
