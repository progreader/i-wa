//
//  MSleepReportViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/2/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MSleepReportViewController.h"
#import "MSelectDateDialogViewController.h"
#import "MSleepdataService.h"
#import "MOk2DialogViewController.h"
#import "MSleepTableViewCell.h"

@interface MSleepReportViewController ()<ServiceCallback>

@property (weak, nonatomic) IBOutlet UILabel *deepSleepMinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusBottomTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (nonatomic, strong) MSleepdataService *sleepdataService;
@property (nonatomic, strong) NSMutableArray *sleepStatusArray;
@property (nonatomic) int currentDayIndex;

@end

@implementation MSleepReportViewController

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
    
    self.sleepStatusArray = [[NSMutableArray alloc] init];
    self.sleepdataService = [[MSleepdataService alloc] initWithSid:@"MSleepdataService" andCallback:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:MSleepTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MSleepTableViewCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.sleepdataService requestSleepDataByDeviceId:[MAppDelegate sharedAppDelegate].deviceId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    NSLog(@"%@", result.data);
    [SVProgressHUD dismiss];
    if ([sid isEqualToString:@"MSleepdataService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            NSArray *objs = result.data[@"objs"];
            if (nil == objs || objs.count == 0) {
                self.deepSleepMinsLabel.text = [NSString stringWithFormat:@"深度睡眠 %d 分钟", 0];
                [self.statusButton setTitle:[NSString stringWithFormat:@"%d", 0] forState:UIControlStateNormal];
                return;
            }
            self.currentDayIndex = 0;
            self.tableView.hidden = YES;
            self.statusButton.hidden = NO;
            self.statusBottomTitleLabel.hidden = NO;
            NSDictionary *obj = objs[0];
            int deep_sleep_mins = [obj[@"deep_sleep_mins"] intValue];
            long long time_begin = [obj[@"time_begin"][@"$date"] longLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_begin/1000];
            long long time_end = [obj[@"time_end"][@"$date"] longLongValue];
            NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time_end/1000];
            int mins = (time_end - time_begin) / 60000.0;
            self.deepSleepMinsLabel.text = [NSString stringWithFormat:@"深度睡眠 %d 分钟", deep_sleep_mins];
            [self.statusButton setTitle:[NSString stringWithFormat:@"%d", mins] forState:UIControlStateNormal];
            
            [self.sleepStatusArray removeAllObjects];
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
                    [self.sleepStatusArray addObject:dayArray];
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
                    [self.sleepStatusArray addObject:dayArray];
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
    if (0 == self.sleepStatusArray.count) {
        return 0;
    }
    NSMutableArray *dayArray = self.sleepStatusArray[self.currentDayIndex];
    return dayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSleepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MSleepTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *obj = self.sleepStatusArray[self.currentDayIndex][indexPath.row];
    long long time_end = [obj[@"time_end"][@"$date"] longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_end/1000];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formater setTimeZone:GTMzone];
    [formater setDateFormat:@"MM-dd HH:mm"];
    int deep_sleep_mins = [obj[@"deep_sleep_mins"] intValue];
    if (deep_sleep_mins > 80) {
        cell.statusLabel.text = [NSString stringWithFormat:@"%@ %@", [formater stringFromDate:date], @"深度睡眠"];
    } else if (deep_sleep_mins > 40) {
        cell.statusLabel.text = [NSString stringWithFormat:@"%@ %@", [formater stringFromDate:date], @"半深度睡眠"];
    }else {
        cell.statusLabel.text = [NSString stringWithFormat:@"%@ %@", [formater stringFromDate:date], @"浅睡状态"];
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
    if (nil != self.sleepStatusArray && self.sleepStatusArray.count > 0) {
        self.tableView.hidden = NO;
        self.statusButton.hidden = YES;
        self.statusBottomTitleLabel.hidden = YES;
    }
}

- (IBAction)didOnLeftButtonTapped:(id)sender
{
    if (nil != self.sleepStatusArray && self.sleepStatusArray.count > 0 && self.currentDayIndex > 0) {
        self.currentDayIndex -= 1;
        NSMutableArray *dayArray = self.sleepStatusArray[self.currentDayIndex];
        NSDictionary *obj = dayArray[0];
        int deep_sleep_mins = [obj[@"deep_sleep_mins"] intValue];
        long long time_begin = [obj[@"time_begin"][@"$date"] longLongValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_begin/1000];
        long long time_end = [obj[@"time_end"][@"$date"] longLongValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time_end/1000];
        int mins = (time_end - time_begin) / 60000.0;
        self.deepSleepMinsLabel.text = [NSString stringWithFormat:@"深度睡眠 %d 分钟", deep_sleep_mins];
        [self.statusButton setTitle:[NSString stringWithFormat:@"%d", mins] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}

- (IBAction)didOnRightButtonTapped:(id)sender
{
    if (nil != self.sleepStatusArray && self.sleepStatusArray.count > 0 && self.currentDayIndex < self.sleepStatusArray.count - 1) {
        self.currentDayIndex += 1;
        NSMutableArray *dayArray = self.sleepStatusArray[self.currentDayIndex];
        NSDictionary *obj = dayArray[0];
        int deep_sleep_mins = [obj[@"deep_sleep_mins"] intValue];
        long long time_begin = [obj[@"time_begin"][@"$date"] longLongValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_begin/1000];
        long long time_end = [obj[@"time_end"][@"$date"] longLongValue];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time_end/1000];
        int mins = (time_end - time_begin) / 60000.0;
        self.deepSleepMinsLabel.text = [NSString stringWithFormat:@"深度睡眠 %d 分钟", deep_sleep_mins];
        [self.statusButton setTitle:[NSString stringWithFormat:@"%d", mins] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}

@end
