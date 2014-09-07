//
//  MBaseDialogViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/29/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MBaseDialogViewController.h"

@interface MBaseDialogViewController ()

@end

@implementation MBaseDialogViewController

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
    CALayer *layer = [self.view layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:8.0];
    [layer setBorderWidth:0.5];
    [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
