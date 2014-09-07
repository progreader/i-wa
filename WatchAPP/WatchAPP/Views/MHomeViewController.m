//
//  MHomeViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/24/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MHomeViewController.h"
#import "MTimelineViewController.h"
#import "MLocusViewController.h"
#import "MSettingListViewController.h"
#import "MReportViewController.h"
#import "MAlertListViewController.h"
#import "JCRBlurView.h"

@interface MHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *locusButton;
@property (weak, nonatomic) IBOutlet UIButton *alertButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIView *tabbarContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *tabbarContainerImageView;
@property (strong, nonatomic) MTimelineViewController *timelineViewController;
@property (strong, nonatomic) MSettingListViewController *settingListViewController;
@property (strong, nonatomic) MReportViewController *reportViewController;
@property (strong, nonatomic) MAlertListViewController *alertListViewController;

@end

@implementation MHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reportViewController = [MReportViewController new];
    [self addChildViewController:self.reportViewController];
    [self.view addSubview:self.reportViewController.view];
    [self.reportViewController.view setHidden:YES];
    
    self.timelineViewController = [MTimelineViewController new];
    [self addChildViewController:self.timelineViewController];
    [self.view addSubview:self.timelineViewController.view];
    [self.timelineViewController.view setHidden:YES];
    
    self.settingListViewController = [MSettingListViewController new];
    [self addChildViewController:self.settingListViewController];
    [self.view addSubview:self.settingListViewController.view];
    [self.settingListViewController.view setHidden:YES];
    
    self.alertListViewController = [MAlertListViewController new];
    [self addChildViewController:self.alertListViewController];
    [self.view addSubview:self.alertListViewController.view];
    [self.alertListViewController.view setHidden:YES];
    
    [self.view bringSubviewToFront:self.tabbarContainerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.tabbarContainerView];
    [self.reportViewController.view setHidden:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnHomeButtonTapped:(id)sender
{
    [self resetAllTabButtons];
    [self.homeButton setSelected:YES];
    [self.timelineViewController.view setHidden:NO];
}

- (IBAction)didOnReportButtonTapped:(id)sender
{
    [self resetAllTabButtons];
    [self.reportButton setSelected:YES];
    [self.reportViewController.view setHidden:NO];
}

- (IBAction)didOnLocusButtonTapped:(id)sender
{
    MLocusViewController *viewController = [MLocusViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)didOnAlertButtonTapped:(id)sender
{
    [self resetAllTabButtons];
    [self.alertButton setSelected:YES];
    [self.alertListViewController.view setHidden:NO];
}

- (IBAction)didOnSettingButtonTapped:(id)sender
{
    [self resetAllTabButtons];
    [self.settingButton setSelected:YES];
    [self.settingListViewController.view setHidden:NO];
}

- (void)resetAllTabButtons
{
    [self.homeButton setSelected:NO];
    [self.reportButton setSelected:NO];
    [self.locusButton setSelected:NO];
    [self.alertButton setSelected:NO];
    [self.settingButton setSelected:NO];
    [self.reportViewController.view setHidden:YES];
    [self.timelineViewController.view setHidden:YES];
    [self.settingListViewController.view setHidden:YES];
    [self.alertListViewController.view setHidden:YES];
}

@end
