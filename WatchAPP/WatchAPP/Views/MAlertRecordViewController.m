//
//  MAlertRecordViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/14/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MAlertRecordViewController.h"
#import "MAlertRecordTableViewCell.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "MAddAlertDialogViewController.h"
#import "MAddAlertViewController.h"

@interface MAlertRecordViewController ()<SGFocusImageFrameDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) NSMutableArray *alertItemList;
@property (strong, nonatomic) MAddAlertViewController *addAlertViewController;

@end

@implementation MAlertRecordViewController

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
    
    self.alertItemList = [[NSMutableArray alloc] init];
    [self.alertItemList addObject:[NSDictionary dictionaryWithObjects:@[ @"第日晚上11:00记得提醒老爸盖被子", @"", @"OFF", @"YES"] forKeys:@[ @"NAME", @"TIME", @"STATUS", @"IS_NEW"]]];
    [self.alertItemList addObject:[NSDictionary dictionaryWithObjects:@[ @"4月18日上午9:00提醒老爸见王医生", @"", @"OFF", @"YES"] forKeys:@[ @"NAME", @"TIME", @"STATUS", @"IS_NEW"]]];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:MAlertRecordTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MAlertRecordTableViewCellIdentifier];
    
    [self initBannerView];
    [self.view bringSubviewToFront:self.headerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBannerView
{
    int length = 2;
    NSDictionary *object1 = [NSDictionary dictionaryWithObjects:@[ @"提醒焦点图", @"提醒焦点图", @"0" ] forKeys:@[ @"icon", @"title", @"index" ]];
    NSDictionary *object2 = [NSDictionary dictionaryWithObjects:@[ @"形象页2", @"bnnaer2", @"1" ] forKeys:@[ @"icon", @"title", @"index" ]];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:@[object1, object2]];
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length + 2];
    if (length > 1) {
        NSDictionary *dict = [tempArray objectAtIndex:length - 1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        item.data = dict;
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++) {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        item.data = dict;
        
        [itemArray addObject:item];
    }
    
    if (length >1) {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
        item.data = dict;
        [itemArray addObject:item];
    }
    CGRect bannerViewFrame = CGRectMake(0, 0, 320, 240);
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:bannerViewFrame delegate:self imageItems:itemArray isAuto:NO];
    bannerView.itemWidth = 320;
    [bannerView scrollToIndex:0];
    [bannerView._pageControl setFrame:CGRectMake(320 - (20 * length), bannerView.frame.size.height - 16, 20 * length, 12)];
    [self.view addSubview:bannerView];
}

- (IBAction)didOnAddAlertButtonTapped:(id)sender
{
    MAddAlertDialogViewController *viewController = [MAddAlertDialogViewController new];
    viewController.mj_dismissDelegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
        if (1 == viewController.resultCode) {
            self.addAlertViewController = [MAddAlertViewController new];
            self.addAlertViewController.alertDataItem = [NSMutableDictionary dictionaryWithObjects:@[ [NSString stringWithFormat:@"提醒%d", self.alertItemList.count + 1], @"", @"OFF", @"YES"] forKeys:@[ @"NAME", @"TIME", @"STATUS", @"IS_NEW"]];
            [self.navigationController pushViewController:self.addAlertViewController animated:YES];
        }
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alertItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAlertRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MAlertRecordTableViewCellIdentifier];
    NSMutableDictionary *settingItem = [self.alertItemList objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", settingItem[@"NAME"]];
    
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
    self.addAlertViewController = [MAddAlertViewController new];
    self.addAlertViewController.alertDataItem = [NSMutableDictionary dictionaryWithObjects:@[ [NSString stringWithFormat:@"提醒%d", self.alertItemList.count + 1], @"", @"OFF", @"NO"] forKeys:@[ @"NAME", @"TIME", @"STATUS", @"IS_NEW"]];
    [self.navigationController pushViewController:self.addAlertViewController animated:YES];
}

@end
