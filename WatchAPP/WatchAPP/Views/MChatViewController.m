//
//  MChatViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/17/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MChatViewController.h"
#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "XHProfileTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "IQKeyboardManager.h"
#import "MUploadMessageService.h"
#import "MDownloadMessageService.h"
#import  "MRequestMessageList.h"
#import "amrdl.h"
@interface MChatViewController ()<AVAudioPlayerDelegate,AVAudioSessionDelegate,ServiceCallback>

@property (nonatomic, strong) NSArray *emotionManagers;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, strong) IBOutlet UILabel *chatTitleLabel;
@property(nonatomic,strong)MUploadMessageService *uploadMessageService;
@property(nonatomic,strong)MDownloadMessageService *downloadMessageService;
@property(nonatomic,strong)NSString *wavPath;
@end

@implementation MChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.messageSender = @"WatchAPP";
    self.chatTitleLabel.text = self.chatTitle;
    
    //谷少鹏 0905 初始化消息服务类
    self.uploadMessageService = [[MUploadMessageService alloc] initWithSid:@"MUploadMessageService" andCallback:self];
    self.downloadMessageService=[[MDownloadMessageService alloc] initWithSid:@"MDownloadMessageService" andCallback:self];
//    NSMutableArray *emotionManagers = [NSMutableArray array];
//    for (NSInteger i = 0; i < 1; i ++) {
//        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
//        emotionManager.emotionName = [NSString stringWithFormat:@"表情%ld", (long)i];
//        NSMutableArray *emotions = [NSMutableArray array];
//        for (NSInteger j = 0; j < 16; j ++) {
//            XHEmotion *emotion = [[XHEmotion alloc] init];
//            NSString *imageName = [NSString stringWithFormat:@"section%ld_emotion%ld.gif", (long)i , (long)j % 16];
//            emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"section%ld_emotion%ld.gif", (long)i , (long)j % 16] ofType:@""];
//            emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
//            [emotions addObject:emotion];
//        }
//        emotionManager.emotions = emotions;
//        
//        [emotionManagers addObject:emotionManager];
//    }
//    
//    self.emotionManagers = emotionManagers;
//    [self.emotionManagerView reloadData];
//    
//    
//    // 添加第三方接入数据
//    NSMutableArray *shareMenuItems = [NSMutableArray array];
//    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location", @"sharemore_myfav"];
//    NSArray *plugTitle = @[@"照片", @"拍摄", @"位置", @"我的收藏"];
//    for (NSString *plugIcon in plugIcons) {
//        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
//        [shareMenuItems addObject:shareMenuItem];
//    }
//    self.shareMenuItems = shareMenuItems;
//    [self.shareMenuView reloadData];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        NSLog(@"Error creating session: %@", [sessionError description]);
    } else {
        [session setActive:YES error:nil];
    }
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    self.player = [[AVAudioPlayer alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)didOnBackButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//谷少鹏 0905 测试接收语音
-(IBAction)didRecevieButtonTapped:(id)sender
{
    
    [self.downloadMessageService requestMessageByID:@"5409a3a3bf483c7ca0cf2358"];
}
-(IBAction)didPlayVoice:(id)sender{

    [self.player initWithContentsOfURL:[NSURL URLWithString:self.wavPath] error:nil];
    [self.player play];
}
#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto: {
            DLog(@"message : %@", message.photo);
            DLog(@"message : %@", message.videoConverPhoto);
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayTextView.message = message;
            disPlayViewController = messageDisplayTextView;
            break;
        }
            break;
        case XHBubbleMessageMediaTypeVoice:
        {
            DLog(@"message : %@", message.voicePath);
            
            NSString *filepath = [NSString stringWithFormat:@"%@.mp3", message.voicePath];
            NSError *playerError;
            AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:filepath] error:&playerError];
            self.player = audioPlayer;
            self.player.volume = 1.0f;
            if (self.player == nil)
            {
                NSLog(@"ERror creating player: %@", [playerError description]);
            }
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
            self.player.delegate = self;
            [self.player play];
            
            [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
            [messageTableViewCell.messageBubbleView.animationVoiceImageView performSelector:@selector(stopAnimating) withObject:nil afterDelay:3];
        }
            break;
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text);
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    displayTextViewController.message = message;
    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

- (void)didSelectedAvatorAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);
    XHProfileTableViewController *profileTableViewController = [[XHProfileTableViewController alloc] init];
    [self.navigationController pushViewController:profileTableViewController animated:YES];
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType
{
    
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES;
}

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
    XHMessage *textMessage = [[XHMessage alloc] initWithText:text sender:sender timestamp:date];
    textMessage.avator = [UIImage imageNamed:@"头像"];
    [self addMessage:textMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
}

- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date
{
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:photo thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date];
    photoMessage.avator = [UIImage imageNamed:@"头像"];
    [self addMessage:photoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
}

- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date
{
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date];
    videoMessage.avator = [UIImage imageNamed:@"头像"];
    [self addMessage:videoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
}

- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString*)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date
{
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:sender timestamp:date];
    voiceMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
    voiceMessage.avator = [UIImage imageNamed:@"头像"];
    [self addMessage:voiceMessage];
    
    //谷少鹏 0905 将amr文件上传到服务器*****
    [self.uploadMessageService requestMessageNewByUpfile:[voicePath stringByAppendingPathExtension:@"amr"] recipient:@"540358f9bf483c14eb11280d"];//admin:53e73319bf483c42f016e2fb //53fc11f0bf483c562a67b9d1
    //*******************************
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
}

- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date
{
    XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:emotionPath sender:sender timestamp:date];
    emotionMessage.avator = [UIImage imageNamed:@"头像"];
    [self addMessage:emotionMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
}

- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date
{
    XHMessage *geoLocationsMessage = [[XHMessage alloc] initWithLocalPositionPhoto:geoLocationsPhoto geolocations:geolocations location:location sender:sender timestamp:date];
    geoLocationsMessage.avator = [UIImage imageNamed:@"头像"];
    [self addMessage:geoLocationsMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2)
        return YES;
    else
        return NO;
}

- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 4) {
        cell.messageBubbleView.displayTextView.textColor = [UIColor colorWithRed:0.106 green:0.586 blue:1.000 alpha:1.000];
    } else {
        cell.messageBubbleView.displayTextView.textColor = [UIColor blackColor];
    }
}

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{

}

//谷少鹏 0905 消息服务回调
- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    if ([sid isEqualToString:@"MUploadMessageService"]) {
          NSLog(@"%@", result.data);
    }
    else if([sid isEqualToString:@"MDownloadMessageService"]){
        NSString *amrUrl =[[MDownloadMessageService getBaseUrl] stringByAppendingString:result.data[@"obj"][@"url"]];
        NSData *amrData=[NSData dataWithContentsOfURL:[NSURL URLWithString:amrUrl]];
        NSString *amrPath=[[self getVoicePath] stringByAppendingPathExtension:@"amr"];
        [amrData writeToFile:amrPath atomically:NO];
        self.wavPath=[[self getVoicePath] stringByAppendingPathExtension:@"wav"];
        [amrdl amrToWav:amrPath savePath:self.wavPath];
        
//        NSLog(@"%@", amrUrl);
    }
}
- (NSString *)getVoicePath {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound", [dateFormatter stringFromDate:now]];
//    recorderPath=[recorderPath stringByAppendingPathExtension:@"wav"];
    return recorderPath;
}
@end
