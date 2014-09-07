//
//  MIntroductionViewController.m
//  Jadebox
//
//  Created by Mike Mai on 6/13/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MIntroductionViewController.h"
#import "MLoginViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "MLoginViewController.h"

@interface MIntroductionViewController ()<SGFocusImageFrameDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) SGFocusImageFrame *bannerView;
@property (nonatomic) int currentIndex;

@end

@implementation MIntroductionViewController

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
    [self initScrollerView];
    [self.view bringSubviewToFront:self.startButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private

- (void)initScrollerView
{
    int length = 3;
    NSMutableArray *tempArray = nil;
    if (!IS_IPHONE5) {
        NSDictionary *object1 = [NSDictionary dictionaryWithObjects:@[ @"引导页1_640X960", @"引导页1_640X960", @"0" ] forKeys:@[ @"icon", @"title", @"index" ]];
        NSDictionary *object2 = [NSDictionary dictionaryWithObjects:@[ @"引导页2_640X960", @"引导页2_640X960", @"1" ] forKeys:@[ @"icon", @"title", @"index" ]];
        NSDictionary *object3 = [NSDictionary dictionaryWithObjects:@[ @"引导页3_640X960", @"引导页3_640X960", @"2" ] forKeys:@[ @"icon", @"title", @"index" ]];
        
        tempArray = [[NSMutableArray alloc] initWithArray:@[object1, object2, object3]];
    } else {
        NSDictionary *object1 = [NSDictionary dictionaryWithObjects:@[ @"引导页1_640X1136", @"引导页1_640X1136", @"0" ] forKeys:@[ @"icon", @"title", @"index" ]];
        NSDictionary *object2 = [NSDictionary dictionaryWithObjects:@[ @"引导页2_640X1136", @"引导页2_640X1136", @"1" ] forKeys:@[ @"icon", @"title", @"index" ]];
        NSDictionary *object3 = [NSDictionary dictionaryWithObjects:@[ @"引导页3_640X1136", @"引导页3_640X1136", @"2" ] forKeys:@[ @"icon", @"title", @"index" ]];
        
        tempArray = [[NSMutableArray alloc] initWithArray:@[object1, object2, object3]];
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length];
    for (int i = 0; i < length; i++) {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        item.data = dict;
        [itemArray addObject:item];
    }
    
    self.bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) delegate:self imageItems:itemArray isAuto:NO isNotLoop:YES];
    self.bannerView.itemWidth = 320;
    self.currentIndex = 0;
    [self.bannerView._pageControl setCenter:CGPointMake(160, self.view.frame.size.height - 30)];
    
    [self.view addSubview:self.bannerView];
}

#pragma mark SGFocusImageFrameDelegate

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    if([item.data[@"index"] isEqualToString:@"3"]) {

    }
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    if (2 == index) {
        self.startButton.alpha = 0;
        self.startButton.hidden = NO;
        [self.view bringSubviewToFront:self.startButton];
        
        [UIView animateWithDuration:0.1 delay:0.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.startButton.alpha = 1;
        } completion:^(BOOL finished) {

        }];
    } else {
        self.startButton.hidden = YES;
    }
}

- (IBAction)didOnStartButtonTapped:(id)sender
{
    MLoginViewController *loginViewController = (MLoginViewController *)self.parentViewController;
    [UIView animateWithDuration:2.0 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bannerView.alpha = 0;
        self.startButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [loginViewController startMotion];
    }];
}

@end
