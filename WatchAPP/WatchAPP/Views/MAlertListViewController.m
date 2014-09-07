//
//  MAlertListViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MAlertListViewController.h"
#import "MAlertRecordTableViewCell.h"
#import "MSelectDateDialogViewController.h"
#import "MAddAlertViewController.h"
#import "MOkOrCancelDialogViewController.h"
#import "MOk2DialogViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "MAlertRecordViewController.h"
#import "AlertItemView.h"
#import "RedPointPageControl.h"
#import "MAddAlertDialogViewController.h"
#import "JCRBlurView.h"

@interface MAlertListViewController ()<SGFocusImageFrameDelegate, AlertItemViewmDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) NSMutableArray *alertItemList;
@property (strong, nonatomic) NSMutableDictionary *alertDataItem;
@property (retain, nonatomic) RedPointPageControl *pageControl;

@end

@implementation MAlertListViewController

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
    
    self.pageControl = [[RedPointPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.origin.y + self.scrollView.frame.size.height - 40, 320, 30)];
    [self.view addSubview:self.pageControl];
    self.scrollView.delegate = self;

    self.alertItemList = [[NSMutableArray alloc] init];
    [self.alertItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"提醒老爸", @"爸爸", @"0", @"NO"] forKeys:@[ @"NAME", @"ICON", @"INDEX", @"IS_DELETING"]]];
    [self.alertItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"提醒老妈", @"头像没上传状态显示", @"1", @"NO"] forKeys:@[ @"NAME", @"ICON", @"INDEX", @"IS_DELETING"]]];
    [self.alertItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"提醒老公", @"头像没上传状态显示", @"2", @"NO"] forKeys:@[ @"NAME", @"ICON", @"INDEX", @"IS_DELETING"]]];
    [self.alertItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"提醒自己", @"头像没上传状态显示", @"3", @"NO"] forKeys:@[ @"NAME", @"ICON", @"INDEX", @"IS_DELETING"]]];
    [self.alertItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"提醒儿子", @"头像没上传状态显示", @"4", @"NO"] forKeys:@[ @"NAME", @"ICON", @"INDEX", @"IS_DELETING"]]];
    
    [self initBannerView];
    [self.view bringSubviewToFront:self.headerView];
    
    [self reloadAlertView];
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

- (void)reloadAlertView
{
    int count = self.alertItemList.count;
    int pageCount = count / 12;
    pageCount += count % 12 == 0 ? 0 : 1;
    
    int currentPage = 0;
    int row = 0;
    for (int i = 0; i < count; i++) {
        int x = 80 * (i % 4) +  currentPage * 4 * 80;
        UIView  *pageView = [[UIView alloc] initWithFrame:CGRectMake(x, row * 90, 320, 90)];
        // cell
        AlertItemView * cell = (AlertItemView *)[[[NSBundle mainBundle] loadNibNamed:@"AlertItemView" owner:self options:nil] lastObject];
        cell.delegate = self;
        cell.frame = CGRectMake(0.0f, 0.0f, 80, 90);
        
        id projinfo = [self.alertItemList objectAtIndex:i];
        [cell.imageView setImage:[UIImage imageNamed:projinfo[@"ICON"]]];
        [cell.label setText:projinfo[@"NAME"]];
        int tag = [projinfo[@"INDEX"] intValue];
        cell.tag = tag;
        
        [pageView addSubview:cell];
        [self.scrollView addSubview:pageView];
        
        if (i != 0 && (i + 1) % 4 == 0) {
            row += 1;
        }
        if (row > 2) {
            row = 0;
        }
        
        if ((i + 1) % 12 == 0) {
            currentPage += 1;
        }
    }
    [self.scrollView setContentSize:CGSizeMake(80 * 4 * pageCount, 90)];
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = 0;
    [self.pageControl updateDots];
    
    if (1 == pageCount) {
        [self.pageControl setHidden:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;
    int offset = x/320.0f;
    self.pageControl.currentPage = offset;
    [self.pageControl updateDots];
}

- (void)alertItemWithId:(int)sid
{
    MAlertRecordViewController *viewController = [MAlertRecordViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
