//
//  MWorkStatusReportViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/2/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MWorkStatusReportViewController.h"
#import "MSelectDateDialogViewController.h"
#import "MPostureDataService.h"
#import "MOk2DialogViewController.h"
#import "SVProgressHUD.h"
#import "MWorkStatusTableViewCell.h"

@interface MWorkStatusReportViewController ()<ServiceCallback>

@property (weak, nonatomic) IBOutlet UIImageView *statusCircleImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (nonatomic, strong) MPostureDataService *postureDataService;
@property (nonatomic, strong) NSMutableArray *workStatusArray;
@property (nonatomic) int currentDayIndex;

@end

@implementation MWorkStatusReportViewController

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
    viewFrame.origin.y = 40;
    viewFrame.size.height = viewFrame.size.height - 40;
    self.view.frame = viewFrame;
    
    self.workStatusArray = [[NSMutableArray alloc] init];
    self.postureDataService = [[MPostureDataService alloc] initWithSid:@"MPostureDataService" andCallback:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:MWorkStatusTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MWorkStatusTableViewCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.postureDataService requestPostureDataByDeviceId:[MAppDelegate sharedAppDelegate].deviceId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    NSLog(@"%@", result.data);
    [SVProgressHUD dismiss];
    if ([sid isEqualToString:@"MPostureDataService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            NSArray *objs = result.data[@"objs"];
            if (nil == objs || objs.count == 0) {
                [self.statusLabel setText:@"无状态"];
                [self.statusButton setTitle:@"无状态" forState:UIControlStateNormal];
                return;
            }
            
            self.currentDayIndex = 0;
            self.tableView.hidden = YES;
            self.statusButton.hidden = NO;
            self.statusLabel.hidden = NO;
            NSDictionary *obj = objs[0];
            int abnormalCount = [obj[@"abnormal_count"] intValue];
            if (abnormalCount > 0) {
                [self.statusLabel setText:@"请注意"];
                [self.statusLabel setTextColor:[UIColor redColor]];
                
                [self.statusButton setTitle:@"异常" forState:UIControlStateNormal];
                [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            } else {
                [self.statusLabel setText:@"请放心"];
                [self.statusLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]]];
                
                [self.statusButton setTitle:@"正常" forState:UIControlStateNormal];
                [self.statusButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]] forState:UIControlStateNormal];
            }
            
            [self.workStatusArray removeAllObjects];
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            [formater setTimeZone:GTMzone];
            [formater setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = nil;
            NSMutableArray *dayArray = nil;
            for (NSDictionary *obj in objs){
                if (nil == dateString) {
                    dayArray = [[NSMutableArray alloc] init];
                    long long time_end = [obj[@"time_end"][@"$date"] longLongValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_end/1000];
                    dateString = [formater stringFromDate:date];
                    [dayArray addObject:obj];
                    [self.workStatusArray addObject:dayArray];
                    continue;
                }
                
                long long time_end = [obj[@"time_end"][@"$date"] longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_end/1000];
                NSString *tempDateString = [formater stringFromDate:date];
                if ([dateString isEqualToString:tempDateString]) {
                    [dayArray addObject:obj];
                } else {
                    dayArray = [[NSMutableArray alloc] init];
                    dateString = tempDateString;
                    [dayArray addObject:obj];
                    [self.workStatusArray addObject:dayArray];
                }
            }
            [self.tableView reloadData];
        } else {
            MOk2DialogViewController *viewController = [MOk2DialogViewController new];
            viewController.message = [NSString stringWithFormat:@"%@", result.data[@"error_desc"]];
            viewController.autoCloseCountDownSecond = 0;
            viewController.mj_dismissDelegate = [MAppDelegate sharedAppDelegate].homeViewController;
            [[MAppDelegate sharedAppDelegate].homeViewController presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                
            }];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == self.workStatusArray.count) {
        return 0;
    }
    NSMutableArray *dayArray = self.workStatusArray[self.currentDayIndex];
    return dayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWorkStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MWorkStatusTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *obj = self.workStatusArray[self.currentDayIndex][indexPath.row];
    long long time_end = [obj[@"time_end"][@"$date"] longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_end/1000];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formater setTimeZone:GTMzone];
    [formater setDateFormat:@"MM-dd HH:mm"];
    int abnormalCount = [obj[@"abnormal_count"] intValue];
    if (abnormalCount > 0) {
        cell.statusLabel.text = [NSString stringWithFormat:@"%@ %@", [formater stringFromDate:date], @"步态异常"];
    } else {
        cell.statusLabel.text = [NSString stringWithFormat:@"%@ %@", [formater stringFromDate:date], @"步态稳定"];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    self.tableView.hidden = YES;
    self.statusButton.hidden = NO;
    self.statusLabel.hidden = NO;
}

- (IBAction)didOnStatusButtonTapped:(id)sender
{
    if (nil != self.workStatusArray && self.workStatusArray.count > 0) {
        self.tableView.hidden = NO;
        self.statusButton.hidden = YES;
        self.statusLabel.hidden = NO;
    }
}

- (IBAction)didOnLeftButtonTapped:(id)sender
{
    if (nil != self.workStatusArray && self.workStatusArray.count > 0 && self.currentDayIndex > 0) {
        self.currentDayIndex -= 1;
        NSMutableArray *dayArray = self.workStatusArray[self.currentDayIndex];
        NSDictionary *obj = dayArray[0];
        int abnormalCount = [obj[@"abnormal_count"] intValue];
        if (abnormalCount > 0) {
            [self.statusLabel setText:@"请注意"];
            [self.statusLabel setTextColor:[UIColor redColor]];
            
            [self.statusButton setTitle:@"异常" forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [self.statusLabel setText:@"请放心"];
            [self.statusLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]]];
            
            [self.statusButton setTitle:@"正常" forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]] forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
    }
}

- (IBAction)didOnRightButtonTapped:(id)sender
{
    if (nil != self.workStatusArray && self.workStatusArray.count > 0 && self.currentDayIndex < self.workStatusArray.count - 1) {
        self.currentDayIndex += 1;
        NSMutableArray *dayArray = self.workStatusArray[self.currentDayIndex];
        NSDictionary *obj = dayArray[0];
        int abnormalCount = [obj[@"abnormal_count"] intValue];
        if (abnormalCount > 0) {
            [self.statusLabel setText:@"请注意"];
            [self.statusLabel setTextColor:[UIColor redColor]];
            
            [self.statusButton setTitle:@"异常" forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [self.statusLabel setText:@"请放心"];
            [self.statusLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]]];
            
            [self.statusButton setTitle:@"正常" forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]] forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
    }
}

@end
