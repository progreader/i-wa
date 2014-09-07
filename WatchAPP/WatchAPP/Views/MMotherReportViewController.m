//
//  MMotherReportViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/2/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MMotherReportViewController.h"
#import "MSelectDateDialogViewController.h"
#import "MReportBottomItemTableViewCell.h"
#import "MEmergencyReportViewController.h"
#import "MSleepReportViewController.h"
#import "MWorkStatusReportViewController.h"
#import "MHeartRateReportViewController.h"

@interface MMotherReportViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UIButton *dayButton;
@property (strong, nonatomic) IBOutlet UIButton *weekButton;
@property (strong, nonatomic) IBOutlet UIButton *monthButton;
@property (strong, nonatomic) IBOutlet UIView *dateContainerView;
@property (strong, nonatomic) IBOutlet UIView *datePopContainerView;
@property (strong, nonatomic) NSMutableArray *bottomItemList;
@property (strong, nonatomic) MEmergencyReportViewController *emergencyReportViewController;
@property (strong, nonatomic) MSleepReportViewController *sleepReportViewController;
@property (strong, nonatomic) MWorkStatusReportViewController *workStatusReportViewController;
@property (strong, nonatomic) MHeartRateReportViewController *heartRateReportViewController;

@end

@implementation MMotherReportViewController

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
    
    self.emergencyReportViewController = [MEmergencyReportViewController new];
    [self addChildViewController:self.emergencyReportViewController];
    [self.view  addSubview:self.emergencyReportViewController.view];
    
    self.sleepReportViewController = [MSleepReportViewController new];
    [self addChildViewController:self.sleepReportViewController];
    [self.view  addSubview:self.sleepReportViewController.view];
    self.sleepReportViewController.view.hidden = YES;
    
    self.workStatusReportViewController = [MWorkStatusReportViewController new];
    [self addChildViewController:self.workStatusReportViewController];
    [self.view  addSubview:self.workStatusReportViewController.view];
    self.workStatusReportViewController.view.hidden = YES;
    
    self.heartRateReportViewController = [MHeartRateReportViewController new];
    [self addChildViewController:self.heartRateReportViewController];
    [self.view  addSubview:self.heartRateReportViewController.view];
    self.heartRateReportViewController.view.hidden = YES;
    
    [self.view bringSubviewToFront:self.datePopContainerView];
    [self.view bringSubviewToFront:self.dateContainerView];
    
    self.bottomItemList = [[NSMutableArray alloc] init];
    [self.bottomItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"紧急呼救", @"紧急呼救", @"NO"] forKeys:@[ @"NAME", @"ICON", @"SELECTED"]]];
    [self.bottomItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"睡眠", @"睡眠", @"YES"] forKeys:@[ @"NAME", @"ICON", @"SELECTED"]]];
    [self.bottomItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"心率", @"心率", @"NO"] forKeys:@[ @"NAME", @"ICON", @"SELECTED"]]];
    [self.bottomItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"步态", @"步态", @"NO"] forKeys:@[ @"NAME", @"ICON", @"SELECTED"]]];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:MReportBottomItemTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MReportBottomItemTableViewCellIdentifier];
    
    CGAffineTransform transfrom = CGAffineTransformMakeRotation(-1.5707963);
    self.tableView.transform = transfrom;
    self.tableView.frame = CGRectMake(0, self.view.frame.size.height - 85 - 50 - 30, 320, 85);
    [self.view bringSubviewToFront:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bottomItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MReportBottomItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MReportBottomItemTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *dataItem = self.bottomItemList[indexPath.row];
    cell.nameLabel.text = dataItem[@"NAME"];
    if ([dataItem[@"SELECTED"] isEqualToString:@"YES"]) {
        cell.bgImageView.hidden = NO;
        cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_click", dataItem[@"ICON"]]];
        switch (indexPath.row) {
            case 0:
            {
                [cell.nameLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"呼救文字颜色"]]];
            }
                break;
            case 1:
            {
                [cell.nameLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"睡眠文字颜色"]]];
            }
                break;
            case 2:
            {
                [cell.nameLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"心率文字颜色"]]];
            }
                break;
            case 3:
            {
                [cell.nameLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]]];
            }
                break;
            default:
                break;
        }
    } else {
        cell.bgImageView.hidden = YES;
        cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", dataItem[@"ICON"]]];
        [cell.nameLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGAffineTransform transfrom = CGAffineTransformMakeRotation(1.5707963);
    cell.transform = transfrom;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSMutableDictionary *dataItem in self.bottomItemList) {
        dataItem[@"SELECTED"] = @"NO";
    }
    NSMutableDictionary *dataItem = self.bottomItemList[indexPath.row];
    dataItem[@"SELECTED"] = @"YES";
    
    [self.tableView reloadData];
    
    switch (indexPath.row) {
        case 0:
        {
            self.emergencyReportViewController.view.hidden = NO;
            self.sleepReportViewController.view.hidden = YES;
            self.heartRateReportViewController.view.hidden = YES;
            self.workStatusReportViewController.view.hidden = YES;
        }
            break;
        case 1:
        {
            self.emergencyReportViewController.view.hidden = YES;
            self.sleepReportViewController.view.hidden = NO;
            self.heartRateReportViewController.view.hidden = YES;
            self.workStatusReportViewController.view.hidden = YES;
        }
            break;
        case 2:
        {
            self.emergencyReportViewController.view.hidden = YES;
            self.sleepReportViewController.view.hidden = YES;
            self.heartRateReportViewController.view.hidden = NO;
            self.workStatusReportViewController.view.hidden = YES;
        }
            break;
        case 3:
        {
            self.emergencyReportViewController.view.hidden = YES;
            self.sleepReportViewController.view.hidden = YES;
            self.heartRateReportViewController.view.hidden = YES;
            self.workStatusReportViewController.view.hidden = NO;
        }
            break;
        default:
        break;    }
}

@end
