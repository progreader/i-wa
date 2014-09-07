//
//  MHeartRateReportViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/2/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MHeartRateReportViewController.h"
#import "MSelectDateDialogViewController.h"
#import "MHeartrateDataService.h"
#import "MOk2DialogViewController.h"
#import "SVProgressHUD.h"
#import "UIViewController+MJPopupViewController.h"
#import "MHeartRateTableViewCell.h"

@interface MHeartRateReportViewController ()<ServiceCallback>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *statusBottomTitleLabel;
@property (nonatomic, strong) MHeartrateDataService *heartrateDataService;
@property (nonatomic, strong) NSMutableArray *heartRateArray;
@property (nonatomic) int currentDayIndex;

@end

@implementation MHeartRateReportViewController

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
    
    self.heartRateArray = [[NSMutableArray alloc] init];
    self.heartrateDataService = [[MHeartrateDataService alloc] initWithSid:@"MHeartrateDataService" andCallback:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:MHeartRateTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MHeartRateTableViewCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.heartrateDataService requestHeartrateDataByDeviceId:[MAppDelegate sharedAppDelegate].deviceId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    NSLog(@"%@", result.data);
    [SVProgressHUD dismiss];
    if ([sid isEqualToString:@"MHeartrateDataService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            NSArray *objs = result.data[@"objs"];
            if (nil == objs || objs.count == 0) {
                [self.statusButton setTitle:@"无状态" forState:UIControlStateNormal];
                return;
            }
            
            self.currentDayIndex = 0;
            self.tableView.hidden = YES;
            self.statusButton.hidden = NO;
            self.statusBottomTitleLabel.hidden = NO;
            NSDictionary *obj = objs[0];
            int heartrate = [obj[@"heartrate"] intValue];
            [self.statusButton setTitle:[NSString stringWithFormat:@"%d", heartrate] forState:UIControlStateNormal];
            if (heartrate > 80) {
                [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            } else {
                [self.statusButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]] forState:UIControlStateNormal];
            }
            
            [self.heartRateArray removeAllObjects];
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
                    [self.heartRateArray addObject:dayArray];
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
                    [self.heartRateArray addObject:dayArray];
                }
            }
            [self.tableView reloadData];
        } else {
            MOk2DialogViewController *viewController = [MOk2DialogViewController new];
            viewController.message = [NSString stringWithFormat:@"%@", result.data[@"error_desc"]];
            viewController.autoCloseCountDownSecond = 0;
            viewController.mj_dismissDelegate = self;
            [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                
            }];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == self.heartRateArray.count) {
        return 0;
    }
    NSMutableArray *dayArray = self.heartRateArray[self.currentDayIndex];
    return dayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHeartRateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MHeartRateTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *obj = self.heartRateArray[self.currentDayIndex][indexPath.row];
    long long time_end = [obj[@"time_end"][@"$date"] longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_end/1000];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formater setTimeZone:GTMzone];
    [formater setDateFormat:@"MM-dd HH:mm"];
    int heartrate = [obj[@"heartrate"] intValue];
    if (heartrate > 80) {
        cell.statusLabel.text = [NSString stringWithFormat:@"%@ %dBpm", [formater stringFromDate:date], heartrate];
    } else {
        cell.statusLabel.text = [NSString stringWithFormat:@"%@ %dBpm", [formater stringFromDate:date], heartrate];
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
    self.statusBottomTitleLabel.hidden = NO;
}

- (IBAction)didOnStatusButtonTapped:(id)sender
{
    if (nil != self.heartRateArray && self.heartRateArray.count > 0) {
        self.tableView.hidden = NO;
        self.statusButton.hidden = YES;
        self.statusBottomTitleLabel.hidden = YES;
    }
}

- (IBAction)didOnLeftButtonTapped:(id)sender
{
    if (nil != self.heartRateArray && self.heartRateArray.count > 0 && self.currentDayIndex > 0) {
        self.currentDayIndex -= 1;
        NSMutableArray *dayArray = self.heartRateArray[self.currentDayIndex];
        NSDictionary *obj = dayArray[0];
        int heartrate = [obj[@"heartrate"] intValue];
        [self.statusButton setTitle:[NSString stringWithFormat:@"%d", heartrate] forState:UIControlStateNormal];
        if (heartrate > 80) {
            [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [self.statusButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]] forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
    }
}

- (IBAction)didOnRightButtonTapped:(id)sender
{
    if (nil != self.heartRateArray && self.heartRateArray.count > 0 && self.currentDayIndex < self.heartRateArray.count - 1) {
        self.currentDayIndex += 1;
        NSMutableArray *dayArray = self.heartRateArray[self.currentDayIndex];
        NSDictionary *obj = dayArray[0];
        int heartrate = [obj[@"heartrate"] intValue];
        [self.statusButton setTitle:[NSString stringWithFormat:@"%d", heartrate] forState:UIControlStateNormal];
        if (heartrate > 80) {
            [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [self.statusButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]] forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
    }
}

@end
