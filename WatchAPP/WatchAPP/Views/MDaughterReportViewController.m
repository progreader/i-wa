//
//  MDaughterReportViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/14/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MDaughterReportViewController.h"
#import "BMapKit.h"
#import "MReportBottomItemTableViewCell.h"

@interface MDaughterReportViewController ()<BMKMapViewDelegate>

@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIButton *dayButton;
@property (strong, nonatomic) IBOutlet UIButton *weekButton;
@property (strong, nonatomic) IBOutlet UIButton *monthButton;
@property (strong, nonatomic) IBOutlet UIView *dateContainerView;
@property (strong, nonatomic) IBOutlet UIView *datePopContainerView;

@end

@implementation MDaughterReportViewController

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
    viewFrame.origin.y = 64;
    viewFrame.size.height = viewFrame.size.height - 64;
    self.view.frame = viewFrame;
    
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    [self.view addSubview:self.mapView];
    
    [self.view bringSubviewToFront:self.datePopContainerView];
    [self.view bringSubviewToFront:self.dateContainerView];
    [self.view bringSubviewToFront:self.bottomView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.mapView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnDateButtonTapped:(id)sender
{
    self.datePopContainerView.hidden = !self.datePopContainerView.hidden;
}

- (IBAction)didOnDayButtonTapped:(id)sender
{
    self.dayButton.selected = YES;
    self.weekButton.selected = NO;
    self.monthButton.selected = NO;
    self.datePopContainerView.hidden = YES;
    
    [self.dateButton setTitle:@"今天的健康" forState:UIControlStateNormal];
}

- (IBAction)didOnWeekButtonTapped:(id)sender
{
    self.dayButton.selected = NO;
    self.weekButton.selected = YES;
    self.monthButton.selected = NO;
    self.datePopContainerView.hidden = YES;
    
    [self.dateButton setTitle:@"7月21日-7月27日" forState:UIControlStateNormal];
}

- (IBAction)didOnMonthButtonTapped:(id)sender
{
    self.dayButton.selected = NO;
    self.weekButton.selected = NO;
    self.monthButton.selected = YES;
    self.datePopContainerView.hidden = YES;
    
    [self.dateButton setTitle:@"2014年1月-6月" forState:UIControlStateNormal];
}

@end
