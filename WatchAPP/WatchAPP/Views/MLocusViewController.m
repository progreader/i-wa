//
//  MLocusViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MLocusViewController.h"
#import "MLocusBottomItemTableViewCell.h"
#import "MSelectDateDialogViewController.h"
#import "MOkOrCancelDialogViewController.h"
#import "BMapKit.h"
#import "JCRBlurView.h"
#import "MLocationDataService.h"
#import "MOk2DialogViewController.h"
#import "SVProgressHUD.h"
#import "UIViewController+MJPopupViewController.h"
#import "MGetLocationFromUnitComService.h"
#import "MLocationDataService.h"

@interface MLocusViewController ()<BMKMapViewDelegate, ServiceCallback>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableBgView;
@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *locusBottomItemList;
@property (strong, nonatomic) NSMutableArray *locationDataArray;
@property (strong, nonatomic) MLocationDataService *locationDataService;
@property (strong, nonatomic) MGetLocationFromUnitComService *getLocationFromUnitComService;

@end

@implementation MLocusViewController

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
    
    self.locusBottomItemList = [[NSMutableArray alloc] init];
    [self.locusBottomItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"老妈", @"头像.jpg"] forKeys:@[ @"NAME", @"ICON"]]];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:MLocusBottomItemTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MLocusBottomItemTableViewCellIdentifier];
    
    CGAffineTransform transfrom = CGAffineTransformMakeRotation(-1.5707963);
    self.tableView.transform = transfrom;
    self.tableView.frame = CGRectMake(0, self.view.frame.size.height - 85, 320, 85);
    self.tableBgView.frame = self.tableView.frame;
    
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    [self.view addSubview:self.mapView];
    
    self.locationDataArray = [[NSMutableArray alloc] init];
    
    [self.view bringSubviewToFront:self.tableBgView];
    [self.view bringSubviewToFront:self.tableView];
    [self.view bringSubviewToFront:self.headerContainerView];
    
    self.locationDataService = [[MLocationDataService alloc] initWithSid:@"MLocationDataService" andCallback:self];
    [self.locationDataService requestLocationDataByDeviceId:[MAppDelegate sharedAppDelegate].deviceId];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.headerContainerView];
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

- (IBAction)didOnLocationButtonTapped:(id)sender
{
    MOkOrCancelDialogViewController *viewController = [MOkOrCancelDialogViewController new];
    viewController.mj_dismissDelegate = self;
    viewController.message = @"你需要月付5元才能使用此功能";
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
        if (1 == viewController.resultCode) {
            MGetLocationFromUnitComService *getLocationFromUnitComService = [[MGetLocationFromUnitComService alloc] initWithUrl:@"http://abt.clbs.cn" sid:@"MGetLocationFromUnitComService" andCallback:self];
            [getLocationFromUnitComService requestGetLocationByPhone:@"18617343587" clinet:@"bytest" password:@"bytest"];
        }
    }];
}

- (IBAction)didOnSearchButtonTapped:(id)sender
{
    MSelectDateDialogViewController *viewController = [MSelectDateDialogViewController new];
    viewController.mj_dismissDelegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:YES dismissed:^{
            
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locusBottomItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLocusBottomItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MLocusBottomItemTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CALayer *layer = [cell.headerImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:30.0];
    [layer setBorderWidth:1.5];
    [layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"登陆页纯背景色"]] CGColor]];
    
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
    
}

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    NSLog(@"%@", result.data);
    [SVProgressHUD dismiss];
    if ([sid isEqualToString:@"MLocationDataService"]) {
        if ([result.data[@"success"] intValue] == 1) {
            NSArray *objs = result.data[@"objs"];
            if (nil == objs || objs.count == 0) {
                MOk2DialogViewController *viewController = [MOk2DialogViewController new];
                viewController.message = [NSString stringWithFormat:@"%@", @"没有轨迹数据!"];
                viewController.autoCloseCountDownSecond = 0;
                viewController.mj_dismissDelegate = self;
                [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                    
                }];
                return;
            }

            [self.locationDataArray removeAllObjects];
            [self.locationDataArray addObjectsFromArray:objs];
            CLLocationCoordinate2D firstPoint;
            firstPoint.latitude = 0;
            for (NSDictionary *obj in self.locationDataArray) {
                NSArray *point = obj[@"point"][@"coordinates"];
                if (nil != point) {
                    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
                    CLLocationCoordinate2D coor;
                    if (firstPoint.latitude == 0) {
                        firstPoint.latitude = [point[1] doubleValue];
                        firstPoint.longitude = [point[0] doubleValue];
                    }
                    coor.latitude = [point[1] doubleValue];
                    coor.longitude = [point[0] doubleValue];
                    pointAnnotation.coordinate = coor;
                    pointAnnotation.title = @"test";
                    pointAnnotation.subtitle = @"此Annotation可拖拽!";
                    [self.mapView addAnnotation:pointAnnotation];
                }
            }
            
            BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance(firstPoint, 1500, 1500);
            [self.mapView setRegion:region animated:YES];
        } else {
            MOk2DialogViewController *viewController = [MOk2DialogViewController new];
            viewController.message = [NSString stringWithFormat:@"%@", result.data[@"error_desc"]];
            viewController.autoCloseCountDownSecond = 0;
            viewController.mj_dismissDelegate = self;
            [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                
            }];
        }
    } else if ([sid isEqualToString:@"MGetLocationFromUnitComService"]) {
        if ([result.data[@"errorCode"] intValue] == 0) {
            MOk2DialogViewController *viewController = [MOk2DialogViewController new];
            viewController.message = [NSString stringWithFormat:@"%@", result.data[@"address"]];
            viewController.autoCloseCountDownSecond = 0;
            viewController.mj_dismissDelegate = self;
            [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
                
            }];
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

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
    ((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
//    ((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    
    return newAnnotation;
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

@end
