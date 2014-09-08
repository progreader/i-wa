//
//  MTimelineViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/30/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MTimelineViewController.h"
#import "MTimelineTableViewCell.h"
#import "MTimelineReplyViewController.h"
#import "MSendMessageConfirmDialogViewController.h"
#import "MSendTextViewController.h"
#import "MSendPictureViewController.h"
#import "MChatMembersViewController.h"
#import "MLocusViewController.h"
#import "MGalleyListViewController.h"
#import "MGalleyViewController.h"
#import "MCommentDialogViewController.h"
#import "MMembersViewController.h"
#import "JCRBlurView.h"
#import "MAddMemberDialogViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "MRequestHomeResourceListService.h"
#import "UIButton+WebCache.h"
#import "MSupportHomeResourceService.h"
#import "MOk2DialogViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

static const int KImageViewTag=100;

@interface MTimelineViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, SGFocusImageFrameDelegate,ServiceCallback>
{
    BOOL isRefresh_;
    BOOL isSubmitSupport_;
    __weak UIButton* curSupportButton_;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (weak, nonatomic) IBOutlet UIView *bannerContainerView;
@property (weak, nonatomic) IBOutlet UIView *bannerTextContainerView;
@property (weak, nonatomic) IBOutlet UIButton *addMemberButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) NSMutableArray *timelineItemList;
@property (strong, nonatomic) MChatMembersViewController *chatMembersViewController;
@property (strong, nonatomic) MMembersViewController *membersSettingViewController;

@property (strong,nonatomic) MRequestHomeResourceListService* requestHomeResourceListService;
@property (strong,nonatomic) MSupportHomeResourceService*
supportHomeResourceService;

@end

@implementation MTimelineViewController

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
    self.chatMembersViewController = [MChatMembersViewController new];
    [self addChildViewController:self.chatMembersViewController];
    [self.view addSubview:self.chatMembersViewController.view];
    self.chatMembersViewController.view.hidden = YES;
        
    self.membersSettingViewController = [MMembersViewController new];
    [self addChildViewController:self.membersSettingViewController];
    [self.view addSubview:self.membersSettingViewController.view];
    self.membersSettingViewController.view.hidden = YES;

    self.membersSettingViewController.memberDataItemList = [[NSMutableArray alloc] init];
    NSMutableDictionary *watchDataItem = [[NSMutableDictionary alloc] init];
    [watchDataItem setObject:@"WATCH" forKey:@"TYPE"];
    [watchDataItem setObject:@"" forKey:@"IMEI"];
    [watchDataItem setObject:@"姐姐" forKey:@"NAME"];
    [watchDataItem setObject:@"" forKey:@"USER_NAME"];
    [watchDataItem setObject:@"" forKey:@"IMAGE_URL"];
    [watchDataItem setObject:[NSString stringWithFormat:@"APP%d", 1] forKey:@"SHORT_NAME"];
    [self.membersSettingViewController.memberDataItemList addObject:watchDataItem];
    
    self.timelineItemList = [[NSMutableArray alloc] init];
    
    /*
    NSMutableArray *replyDataItemList = [[NSMutableArray alloc] init];
    [replyDataItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"女儿", @"爷爷拍的花好漂亮啊。", @"TEXT"] forKeys:@[ @"REPLY_USER", @"REPLY_CONTENT", @"REPLY_CONTENT_TYPE"]]];
    [replyDataItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"老公", @"爸爸也会拍花？", @"TEXT"] forKeys:@[ @"REPLY_USER", @"REPLY_CONTENT", @"REPLY_CONTENT_TYPE"]]];
    [self.timelineItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"爸爸.png", @"APP", @"HEART", @"自己，老公，女儿", @"1分钟前", @"", @"样例1.jpg", @"YES", replyDataItemList, @"爸爸"] forKeys:@[ @"ICON_URL", @"FROM", @"ACTION_TYPE", @"REPLY_USERS", @"TIME", @"COMMENT", @"IMAGE_URL", @"IS_SUPPORT", @"REPLY_LIST", @"MENBER_NAME"]]];

//    [self.timelineItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"爸爸.png", @"WATCH", @"HEART", @"自己，老公，女儿", @"5分钟前", @"老爸正在回家中...", @"", @"NO", @"", @"爸爸"] forKeys:@[ @"ICON_URL", @"FROM", @"ACTION_TYPE", @"REPLY_USERS", @"TIME", @"COMMENT", @"IMAGE_URL", @"IS_SUPPORT", @"REPLY_LIST", @"MENBER_NAME"]]];

    [self.timelineItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"妹妹.png", @"APP", @"HEART", @"自己，老公，女儿", @"50分钟前", @"梦想中的别墅", @"样例2.jpg", @"YES", @"", @"妹妹"] forKeys:@[ @"ICON_URL", @"FROM", @"ACTION_TYPE", @"REPLY_USERS", @"TIME", @"COMMENT", @"IMAGE_URL", @"IS_SUPPORT", @"REPLY_LIST", @"MENBER_NAME"]]];
    
    [self.timelineItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"爸爸.png", @"APP", @"HEART", @"自己，老公，女儿", @"1小时前", @"提醒：爸爸的睡眠昨晚不是很好。", @"样例3.png", @"YES", @"", @"老爸"] forKeys:@[ @"ICON_URL", @"FROM", @"ACTION_TYPE", @"REPLY_USERS", @"TIME", @"COMMENT", @"IMAGE_URL", @"IS_SUPPORT", @"REPLY_LIST", @"MENBER_NAME"]]];
    
    replyDataItemList = [[NSMutableArray alloc] init];
    [replyDataItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"爸爸", @"声音图标3.png", @"VOICE"] forKeys:@[ @"REPLY_USER", @"REPLY_CONTENT", @"REPLY_CONTENT_TYPE"]]];
    [replyDataItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"妈妈", @"哈", @"TEXT"] forKeys:@[ @"REPLY_USER", @"REPLY_CONTENT", @"REPLY_CONTENT_TYPE"]]];
    [replyDataItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"自己", @"拍的不错", @"TEXT"] forKeys:@[ @"REPLY_USER", @"REPLY_CONTENT", @"REPLY_CONTENT_TYPE"]]];
    [replyDataItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"老公", @"嗯", @"TEXT"] forKeys:@[ @"REPLY_USER", @"REPLY_CONTENT", @"REPLY_CONTENT_TYPE"]]];
    [self.timelineItemList addObject:[NSMutableDictionary dictionaryWithObjects:@[ @"女儿.png", @"APP", @"SUPROT", @"全部", @"2小时前", @"", @"样例4.png", @"YES", replyDataItemList, @"女儿"] forKeys:@[ @"ICON_URL", @"FROM", @"ACTION_TYPE", @"REPLY_USERS", @"TIME", @"COMMENT", @"IMAGE_URL", @"IS_SUPPORT", @"REPLY_LIST", @"MENBER_NAME"]]];
     */
    
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:MTimelineTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:MTimelineTableViewCellIdentifier];

    [self initBannerView];
    [self.bannerContainerView bringSubviewToFront:self.bannerTextContainerView];
    [self.view bringSubviewToFront:self.headerContainerView];
    
    self.requestHomeResourceListService = [[MRequestHomeResourceListService alloc] initWithSid:@"MRequestHomeResourceListService" andCallback:self];
    self.supportHomeResourceService = [[MSupportHomeResourceService alloc] initWithSid:@"MSupportHomeResourceService" andCallback:self];
    
    [self.tableView addHeaderWithCallback:^{
        [self requestRefresh];
    }];
    [self.tableView addFooterWithCallback:^{
        [self requestMore];
    }];
    
    [self performSelector:@selector(handleSendSuccess) withObject:nil afterDelay:1.0];
}

-(void)requestRefresh
{
    isRefresh_=YES;
    [self.requestHomeResourceListService requestList];
}

-(void)requestMore
{
    isRefresh_=NO;
    [self.requestHomeResourceListService requestList];
}

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
    BOOL success=[[result.data objectForKey:@"success"] intValue]==1;
    
    if([sid isEqualToString:@"MSupportHomeResourceService" ])
    {
        if(success)
        {
            id loginData=[MAppDelegate sharedAppDelegate].loginData;
            NSString* loginUserName=[[loginData objectForKey:@"obj"] objectForKey:@"username"];
            NSMutableDictionary *dataItem = [self.timelineItemList objectAtIndex:curSupportButton_.tag];
            NSMutableArray *supportPersonNames = dataItem[@"supportPersonNames"];
            
            if (!isSubmitSupport_)
            {
                dataItem[@"IS_SUPPORT"] = @"NO";
                [curSupportButton_ setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];

                if([supportPersonNames containsObject:loginUserName])
                {
                    [supportPersonNames removeObject:loginUserName];
                }
            }
            else
            {
                dataItem[@"IS_SUPPORT"] = @"YES";
                [curSupportButton_ setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
                
                if(![supportPersonNames containsObject:loginUserName])
                {
                    [supportPersonNames addObject:loginUserName];
                }
            }
            
            [self.tableView reloadData];
        }
    }
    else if(success)
    {
        if(isRefresh_)
        {
            [self.timelineItemList removeAllObjects];
        }
        
        NSArray* objs=[result.data objectForKey:@"objs"];
        
        NSLog(@"%@",result.data);
        
        for (NSDictionary* objDic in objs)
        {
            NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithCapacity:10];
            NSDictionary* createByDic=[objDic objectForKey:@"$created_by"];
            
            NSString* userId=[[createByDic objectForKey:@"_id"] objectForKey:@"$oid"];
            
            NSString* avatarUrl=[createByDic objectForKey:@"avatar_url"];
            
            NSString* pageId=[[objDic objectForKey:@"_id"] objectForKey:@"$oid"];
            NSString* from=@"";//WATCH
            NSString* actionType=@"HEART";
            NSString* createByUserName=@"";
            double timestamp=[[[objDic objectForKey:@"created_at"] objectForKey: @"$date"] doubleValue]/1000-8*60*60;
            NSString* time=[[self class] dateTimeStringWithTimeIntervalSince1970:timestamp dateTimeFormat:@"MM-dd hh:mm"];
            NSString* comment=[objDic objectForKey:@"body"];
            NSString* imgUrl=[objDic objectForKey:@"url"];
            
            NSString* REPLY_LIST=nil;
   
            NSMutableDictionary* memberDic=[NSMutableDictionary dictionaryWithCapacity:5];
            NSArray* members=[[objDic objectForKey:@"$group"] objectForKey:@"members"];
            for (NSDictionary* tempDic in members)
            {
                NSString* personName=[tempDic objectForKey:@"member_name"];
                NSString* personId=[[tempDic objectForKey:@"person"] objectForKey:@"$oid"];
                [memberDic setObject:personName forKey:personId];
                
                if(createByUserName.length==0 && [userId isEqualToString:personId])
                {
                    createByUserName=personName;
                }
            }

            id loginData=[MAppDelegate sharedAppDelegate].loginData;
            NSString* loginUserId=[[[loginData objectForKey:@"obj"] objectForKey:@"_id"] objectForKey:@"$oid"];
             NSString* loginUserName=[[loginData objectForKey:@"obj"] objectForKey:@"username"];
            
            NSMutableArray* supportPersonNames=[NSMutableArray arrayWithCapacity:50];
            NSString* issupport=@"NO";
            NSArray* stars=[objDic objectForKey:@"stars"];
            for (NSDictionary* tempDic in stars)
            {
                NSString* personId=[[tempDic objectForKey:@"created_by"] objectForKey:@"$oid"];
                if([loginUserId isEqualToString:personId])
                {
                    issupport=@"YES";
                }
                
                NSString* personName=[memberDic objectForKey:personId];
                [supportPersonNames addObject:personName];
            }

            if(supportPersonNames)
            {
                [dic setObject:supportPersonNames forKey:@"supportPersonNames"];
            }
            if(memberDic)
            {
                [dic setObject:memberDic forKey:@"memberDic"];
            }
            [dic setObject:pageId forKey:@"pageId"];
            if(avatarUrl)
            {
                [dic setObject:avatarUrl forKey:@"ICON_URL"];
            }
            if(from)
            {
                [dic setObject:from forKey:@"FROM"];
            }
            if(actionType)
            {
                [dic setObject:actionType forKey:@"ACTION_TYPE"];
            }
            if(time)
            {
                [dic setObject:time forKey:@"TIME"];
            }
            if(comment)
            {
                [dic setObject:comment forKey:@"COMMENT"];
            }
            
            if(imgUrl)
            {
                [dic setObject:imgUrl forKey:@"IMAGE_URL"];
            }
            if(issupport)
            {
                [dic setObject:issupport forKey:@"IS_SUPPORT"];
            }
            if(REPLY_LIST)
            {
                [dic setObject:REPLY_LIST forKey:@"REPLY_LIST"];
            }
            if(createByUserName)
            {
                [dic setObject:createByUserName forKey:@"MENBER_NAME"];
            }
 
            [self.timelineItemList addObject:dic];
        }
        
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
    [self.view bringSubviewToFront:self.headerContainerView];
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
    [bannerView._pageControl setFrame:CGRectMake(320 - (20 * length), bannerView.frame.size.height - 10, 20 * length, 12)];
    bannerView._pageControl.hidden = YES;
    [self.bannerContainerView addSubview:bannerView];
}

- (IBAction)didOnAddMemberButtonTapped:(id)sender
{
    MAddMemberDialogViewController *viewController = [MAddMemberDialogViewController new];
    viewController.mj_dismissDelegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:YES dismissed:^{
        UIButton *button = sender;
        button.tag = viewController.resultCode;
        switch (viewController.resultCode) {
            case 1:
            {
                [self.membersSettingViewController didOnAddMemberButtonTapped:button];
            }
                break;
            case 2:
            {
                [self.membersSettingViewController didOnAddMemberButtonTapped:button];
            }
                break;
            default:
                break;
        }
    }];
}

- (IBAction)didOnSegmentedControlValueChanged:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            self.cameraButton.hidden = YES;
            self.addMemberButton.hidden = YES;
            self.chatMembersViewController.view.hidden = NO;
            self.membersSettingViewController.view.hidden = YES;
        }
            break;
        case 1:
        {
            self.cameraButton.hidden = NO;
            self.addMemberButton.hidden = YES;
            self.chatMembersViewController.view.hidden = YES;
            self.membersSettingViewController.view.hidden = YES;
        }
            break;
        case 2:
        {
            self.cameraButton.hidden = YES;
            self.addMemberButton.hidden = NO;
            self.chatMembersViewController.view.hidden = YES;
            self.membersSettingViewController.view.hidden = NO;
        }
            break;
    }
}

- (IBAction)didOnSendMessageButtonTapped:(id)sender
{
    MSendMessageConfirmDialogViewController *viewController = [MSendMessageConfirmDialogViewController new];
    viewController.mj_dismissDelegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:YES dismissed:^{
        switch (viewController.resultCode) {
            case 1:
            {
                [self takeThePhoto];
            }
                break;
            case 2:
            {
                [self pickThePhoto];
            }
                break;
            case 3:
            {
                MSendTextViewController *viewController = [MSendTextViewController new];
                viewController.delegate=self;
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)didOnLocusButtonTapped:(id)sender
{
    MLocusViewController *viewController = [MLocusViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didOnSupportButtonTapped:(id)sender
{
    UIButton *button = sender;
    curSupportButton_=button;
    NSMutableDictionary *dataItem = [self.timelineItemList objectAtIndex:button.tag];
    NSString* pageId=dataItem[@"pageId"];
    if ([dataItem[@"IS_SUPPORT"] isEqualToString:@"YES"])
    {
        isSubmitSupport_=NO;
        [self.supportHomeResourceService submitSupportPageId:pageId support:isSubmitSupport_];
    }
    else
    {
        isSubmitSupport_=YES;
        [self.supportHomeResourceService submitSupportPageId:pageId support:isSubmitSupport_];
    }
}

- (void)didOnCommentButtonTapped:(id)sender
{
    MCommentDialogViewController *viewController = [MCommentDialogViewController new];
    viewController.allowsSendFace = NO;
    viewController.allowsSendVoice=NO;
    viewController.allowsSendMultiMedia=NO;
    viewController.allowsPanToDismissKeyboard = NO;
    viewController.mj_dismissDelegate = self;
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:YES dismissed:^{
        
    }];
}

- (void)didOnCommentImageButtonTapped:(id)sender
{
    MGalleyListViewController *viewController = [MGalleyListViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    
    //MGalleyViewController *viewController2 = [MGalleyViewController new];
    //[self.navigationController pushViewController:viewController2 animated:YES];
}

- (void)didOnMemberImageButtonTapped:(id)sender
{
    MGalleyListViewController *viewController = [MGalleyListViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)takeThePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)pickThePhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    MSendPictureViewController *viewController = [MSendPictureViewController new];
    viewController.pickedImage=image;
    viewController.delegate=self;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    MSendPictureViewController *viewController = [MSendPictureViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - MSendDelegate
-(void)handleSendSuccess
{
    [self.tableView headerBeginRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timelineItemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTimelineTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:MTimelineTableViewCellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.locusButton.tag = indexPath.row;
    cell.supportButton.tag = indexPath.row;
    cell.commentButton.tag = indexPath.row;
    cell.commentImageButton.tag = indexPath.row;
    cell.memberImageButton.tag = indexPath.row;
    
    if (nil != cell.replyViewController) {
        [cell.replyViewController.view removeFromSuperview];
        [cell.replyViewController removeFromParentViewController];
        cell.replyViewController = nil;
    }
   
    [cell.locusButton addTarget:self action:@selector(didOnLocusButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.supportButton addTarget:self action:@selector(didOnSupportButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(didOnCommentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentImageButton addTarget:self action:@selector(didOnCommentImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.memberImageButton addTarget:self action:@selector(didOnMemberImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableDictionary *dataItem = [self.timelineItemList objectAtIndex:indexPath.row];
    if ([dataItem[@"IS_SUPPORT"] isEqualToString:@"YES"]) {
        [cell.supportButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    } else {
        [cell.supportButton setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
    }
    
    cell.memeberNameLabel.text = dataItem[@"MENBER_NAME"];
    cell.memberCommentLabel.text = dataItem[@"COMMENT"];
    NSString *iconUrl = dataItem[@"ICON_URL"];
    //[cell.memberImageButton setImage:[UIImage imageNamed:iconUrl] forState:UIControlStateNormal];
    [cell.memberImageButton sd_setImageWithURL:[NSURL URLWithString:iconUrl relativeToURL:[NSURL URLWithString:[MApi getBaseUrl]]] forState:UIControlStateNormal];
    
    if ([dataItem[@"FROM"] isEqualToString:@"WATCH"]) {
        [cell.locusButton setHidden:NO];
        [cell.supportButton setHidden:YES];
    } else {
        [cell.locusButton setHidden:YES];
        [cell.supportButton setHidden:NO];
    }
    
    int cellHeight = 262;
    int y = 53;
    if ([NSString checkIfEmpty:dataItem[@"COMMENT"]]) {
        [cell.memberCommentLabel setHidden:YES];
        cellHeight -= 25;
    } else {
        [cell.memberCommentLabel setHidden:NO];
        y += 25;
    }
    
    UIImageView* imageView=(UIImageView*)[cell.commentImageButton.superview viewWithTag:KImageViewTag];
    [cell.commentImageButton setImage:nil forState:UIControlStateNormal];
    
    if ([NSString checkIfEmpty:dataItem[@"IMAGE_URL"]]) {
        [imageView removeFromSuperview];
        cellHeight -= 145;
    } else {
        CGRect commentImageButtonFrame = cell.commentImageButton.frame;
        commentImageButtonFrame.origin.y = y;
        cell.commentImageButton.frame = commentImageButtonFrame;
        
        if(!imageView)
        {
            CGRect r=cell.commentImageButton.frame;
            imageView=[[UIImageView alloc] initWithImage:cell.commentImageButton.imageView.image];
            imageView.contentMode=UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds=YES;
            [cell.commentImageButton.superview addSubview:imageView];
            imageView.frame=r;
            imageView.tag=KImageViewTag;
        }
        
        NSString *imageUrl = dataItem[@"IMAGE_URL"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl relativeToURL:[NSURL URLWithString:[MApi getBaseUrl]]]];
        
        //[cell.commentImageButton setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];

        y += 145;
    }

    cell.timeLabel.text = dataItem[@"TIME"];
    CGRect timeLabelFrame = cell.timeLabel.frame;
    timeLabelFrame.origin.y = y;
    cell.timeLabel.frame = timeLabelFrame;
    
    y += 25;
    
    UIView *replyView = [cell viewWithTag:10000 + indexPath.row];
    if (nil != replyView) {
        [replyView setHidden:YES];
        [replyView removeFromSuperview];
    }
    
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = cellHeight;
    cell.frame = cellFrame;
    
    if ([dataItem[@"REPLY_LIST"] isKindOfClass:[NSString class]]) {
        
    } else {
        NSMutableArray *replyItemDataList = dataItem[@"REPLY_LIST"];
        MTimelineReplyViewController *viewController = [MTimelineReplyViewController new];
        cell.replyViewController = viewController;
        NSString* names=@"";
        NSArray *supportPersonNames = dataItem[@"supportPersonNames"];
        for (NSString* name in supportPersonNames)
        {
            names=[names stringByAppendingFormat:@"%@ ",name];
        }
        viewController.replyUsers = names;
        viewController.actionType = dataItem[@"ACTION_TYPE"];
        viewController.replyItemDataList = replyItemDataList;
        viewController.view.tag = 10000 + indexPath.row;
        [self addChildViewController:viewController];
        CGRect viewControllerFrame = viewController.view.frame;
        viewControllerFrame.origin.x = timeLabelFrame.origin.x;
        viewControllerFrame.origin.y = y - 5;
        viewControllerFrame.size.height = 26 * replyItemDataList.count + 50;
        [cell addSubview:viewController.view];
         viewController.view.frame = viewControllerFrame;
        
        CGRect cellFrame = cell.frame;
        cellFrame.size.height += 26 * replyItemDataList.count + 50 - 15;
        cell.frame = cellFrame;
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
    NSLog(@"aa");
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    MGalleyListViewController *viewController = [MGalleyListViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}

+(NSString*)dateTimeStringWithTimeIntervalSince1970:(NSTimeInterval)secs dateTimeFormat:(NSString*)dateTimeFormat
{
    NSDate* theDate=[NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateTimeFormat];
    NSString* timeStr = [dateFormatter stringFromDate:theDate];
    return timeStr;
}

@end
