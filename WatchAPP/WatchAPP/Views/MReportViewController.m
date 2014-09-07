//
//  MReportViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MReportViewController.h"
#import "UIImage+Blur.h"
#import "MReportBottomItemTableViewCell.h"
#import "MFatherReportViewController.h"
#import "MMotherReportViewController.h"
#import "MEmergencyReportViewController.h"
#import "MSleepReportViewController.h"
#import "MWorkStatusReportViewController.h"
#import "MHeartRateReportViewController.h"
#import "MOk2DialogViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "MHusbandReportViewController.h"
#import "JCRBlurView.h"
#import "MHusbandReportViewController.h"
#import "MMotherReportViewController.h"
#import "MFatherReportViewController.h"
#import "MDaughterReportViewController.h"

@interface MReportViewController ()<SGFocusImageFrameDelegate>

@property (weak, nonatomic) IBOutlet UIButton *fatherButton;
@property (weak, nonatomic) IBOutlet UIButton *motherButton;
@property (weak, nonatomic) IBOutlet UIButton *husbandButton;
@property (weak, nonatomic) IBOutlet UIButton *daughterButton;
@property (weak, nonatomic) IBOutlet UIView *fatherBottomLineView;
@property (weak, nonatomic) IBOutlet UIView *motherBottomLineView;
@property (weak, nonatomic) IBOutlet UIView *husbandBottomLineView;
@property (weak, nonatomic) IBOutlet UIView *daughterBottomLineView;
@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (strong, nonatomic) NSMutableArray *reportBottomItemList;
@property (strong, nonatomic) UINavigationController *myNavigationController;
@property (strong, nonatomic) MFatherReportViewController *fatherReportViewController;
@property (strong, nonatomic) MMotherReportViewController *motherReportViewController;
@property (strong, nonatomic) MHusbandReportViewController *husbandReportViewController;
@property (strong, nonatomic) MDaughterReportViewController *daughterReportViewController;

@end

@implementation MReportViewController

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
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= 50;
    self.view.frame = viewFrame;
    
    self.fatherReportViewController = [MFatherReportViewController new];
    self.myNavigationController = [[UINavigationController alloc] initWithRootViewController:self.fatherReportViewController];
    self.myNavigationController.navigationBar.hidden = YES;
    [self addChildViewController:self.myNavigationController];
    [self.view addSubview:self.myNavigationController.view];
    
    self.motherReportViewController = [MMotherReportViewController new];
    self.husbandReportViewController = [MHusbandReportViewController new];
    self.daughterReportViewController = [MDaughterReportViewController new];

    [self.view bringSubviewToFront:self.headerContainerView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnFatherButtonTapped:(id)sender
{
    self.fatherButton.selected = YES;
    self.fatherBottomLineView.hidden = NO;
    self.motherButton.selected = NO;
    self.motherBottomLineView.hidden = YES;
    self.husbandButton.selected = NO;
    self.husbandBottomLineView.hidden = YES;
    self.daughterButton.selected = NO;
    self.daughterBottomLineView.hidden = YES;
    
    [self.myNavigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)didOnMotherButtonTapped:(id)sender
{
    self.fatherButton.selected = NO;
    self.fatherBottomLineView.hidden = YES;
    self.motherButton.selected = YES;
    self.motherBottomLineView.hidden = NO;
    self.husbandButton.selected = NO;
    self.husbandBottomLineView.hidden = YES;
    self.daughterButton.selected = NO;
    self.daughterBottomLineView.hidden = YES;
    
    [self.myNavigationController popToRootViewControllerAnimated:NO];
    [self.myNavigationController pushViewController:self.motherReportViewController animated:NO];
}

- (IBAction)didOnHusbandButtonTapped:(id)sender
{
    self.fatherButton.selected = NO;
    self.fatherBottomLineView.hidden = YES;
    self.motherButton.selected = NO;
    self.motherBottomLineView.hidden = YES;
    self.husbandButton.selected = YES;
    self.husbandBottomLineView.hidden = NO;
    self.daughterButton.selected = NO;
    self.daughterBottomLineView.hidden = YES;
    
    [self.myNavigationController popToRootViewControllerAnimated:NO];
    [self.myNavigationController pushViewController:self.husbandReportViewController animated:NO];
}

- (IBAction)didOnDaughterButtonTapped:(id)sender
{
    self.fatherButton.selected = NO;
    self.fatherBottomLineView.hidden = YES;
    self.motherButton.selected = NO;
    self.motherBottomLineView.hidden = YES;
    self.husbandButton.selected = NO;
    self.husbandBottomLineView.hidden = YES;
    self.daughterButton.selected = YES;
    self.daughterBottomLineView.hidden = NO;

    [self.myNavigationController popToRootViewControllerAnimated:NO];
    [self.myNavigationController pushViewController:self.daughterReportViewController animated:NO];
}

@end
