//
//  MEmergencyReportViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/2/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MEmergencyReportViewController.h"
#import "MSelectDateDialogViewController.h"
#import "MSosDataService.h"
#import "MSosTableViewCell.h"
#import "MOk2DialogViewController.h"

@interface MEmergencyReportViewController ()<ServiceCallback>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (nonatomic, strong) MSosDataService *sosDataService;
@property (nonatomic, strong) NSMutableArray *workStatusArray;
@property (nonatomic) int currentDayIndex;

@end

@implementation MEmergencyReportViewController

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
    self.sosDataService = [[MSosDataService alloc] initWithSid:@"MSosDataService" andCallback:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:MSosTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MSosTableViewCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.sosDataService requestSosDataByDeviceId:[MAppDelegate sharedAppDelegate].deviceId];
    
//    [self.sosDataService requestSosDataByDeviceId:@"000030303030303"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    NSLog(@"%@", result.data);
    [SVProgressHUD dismiss];
    if ([sid isEqualToString:@"MSosDataService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            NSArray *objs = result.data[@"objs"];
            if (nil == objs || objs.count == 0) {
                [self.statusLabel setText:@"无状态"];
                [self.statusButton setTitle:@"无状态" forState:UIControlStateNormal];
                return;
            }
            
            [self.workStatusArray removeAllObjects];
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            [formater setTimeZone:GTMzone];
            [formater setDateFormat:@"yyyy-MM-dd"];
            
            NSDictionary *firstObj = objs[0];
            long long first_time_end = [firstObj[@"time_end"][@"$date"] longLongValue];
            NSDate *firstObjeDate = [NSDate dateWithTimeIntervalSince1970:first_time_end/1000];
            if (![[formater stringFromDate:firstObjeDate] isEqualToString:[formater stringFromDate:[NSDate date]]]) {
                [self.workStatusArray addObject:[[NSMutableArray alloc] init]];
            }
            
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

            self.currentDayIndex = 0;
            self.tableView.hidden = YES;
            self.statusButton.hidden = NO;
            self.statusLabel.hidden = NO;
            NSArray *firstArray = self.workStatusArray[0];
            if (firstArray.count > 0) {
                [self.statusLabel setText:@"请注意"];
                [self.statusLabel setTextColor:[UIColor redColor]];
                [self.statusButton setTitle:[NSString stringWithFormat:@"%d 次", firstArray.count] forState:UIControlStateNormal];
                [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            } else {
                [self.statusLabel setText:@"请放心"];
                [self.statusLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]]];
                
                [self.statusButton setTitle:[NSString stringWithFormat:@"%d 次", 0] forState:UIControlStateNormal];
                [self.statusButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]] forState:UIControlStateNormal];
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
    MSosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MSosTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *obj = self.workStatusArray[self.currentDayIndex][indexPath.row];
    long long time_end = [obj[@"time_end"][@"$date"] longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_end/1000];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formater setTimeZone:GTMzone];
    [formater setDateFormat:@"MM-dd HH:mm"];

    cell.statusLabel.text = [NSString stringWithFormat:@"%@ %@", [formater stringFromDate:date], obj[@"address"]];
    CGSize fontSize = [cell.statusLabel.text sizeWithFont:cell.statusLabel.font constrainedToSize:CGSizeMake(149, CGFLOAT_MAX)];
    cell.statusLabel.frame = CGRectMake(28, 2, cell.statusLabel.frame.size.width, fontSize.height);
    
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = cell.statusLabel.frame.size.height + 4;
    cell.frame = cellFrame;
    
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
        NSMutableArray *dayArray = self.workStatusArray[self.currentDayIndex];
        if (dayArray.count > 0) {
            self.tableView.hidden = NO;
            self.statusButton.hidden = YES;
            self.statusLabel.hidden = NO;
        }
    }
}

- (IBAction)didOnLeftButtonTapped:(id)sender
{
    if (nil != self.workStatusArray && self.workStatusArray.count > 0 && self.currentDayIndex > 0) {
        self.currentDayIndex -= 1;
        NSMutableArray *dayArray = self.workStatusArray[self.currentDayIndex];
        if (dayArray.count > 0) {
            [self.statusLabel setText:@"请注意"];
            [self.statusLabel setTextColor:[UIColor redColor]];
            [self.statusButton setTitle:[NSString stringWithFormat:@"%d 次", dayArray.count] forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            self.tableView.hidden = YES;
            self.statusButton.hidden = NO;
            self.statusLabel.hidden = NO;
            
            [self.statusLabel setText:@"请放心"];
            [self.statusLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]]];
            
            [self.statusButton setTitle:[NSString stringWithFormat:@"%d 次", 0] forState:UIControlStateNormal];
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
        if (dayArray.count > 0) {
            [self.statusLabel setText:@"请注意"];
            [self.statusLabel setTextColor:[UIColor redColor]];
            [self.statusButton setTitle:[NSString stringWithFormat:@"%d 次", dayArray.count] forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            self.tableView.hidden = YES;
            self.statusButton.hidden = NO;
            self.statusLabel.hidden = NO;
            
            [self.statusLabel setText:@"请放心"];
            [self.statusLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]]];
            
            [self.statusButton setTitle:[NSString stringWithFormat:@"%d 次", 0] forState:UIControlStateNormal];
            [self.statusButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"步态文字颜色"]] forState:UIControlStateNormal];
        }
        
        [self.tableView reloadData];
    }
}

@end
