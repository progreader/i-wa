//
//  MGalleyPictureViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MGalleyPictureViewController.h"
#import "MSavePictureDialogViewController.h"
#import "MOk2DialogViewController.h"
#import "UIImageView+WebCache.h"
#import "MApi.h"

@interface MGalleyPictureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation MGalleyPictureViewController

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
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.iconUrl relativeToURL:[NSURL URLWithString:[MApi getBaseUrl]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnMoreButtonTapped:(id)sender
{
    MSavePictureDialogViewController *viewController = [MSavePictureDialogViewController new];
       viewController.mj_dismissDelegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:YES dismissed:^{
        
        MOk2DialogViewController *viewController = [MOk2DialogViewController new];
        viewController.message = @"功能尚在开发中!";
        viewController.mj_dismissDelegate = self;
        [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
            [self closePopView:sender];
        }];
        
    }];
}

@end
