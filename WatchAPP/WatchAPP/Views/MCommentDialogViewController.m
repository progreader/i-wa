//
//  MCommentDialogViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/17/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MCommentDialogViewController.h"
#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "XHProfileTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "IQKeyboardManager.h"

@interface MCommentDialogViewController ()<AVAudioPlayerDelegate,AVAudioSessionDelegate>

@property (nonatomic, strong) NSArray *emotionManagers;
@property (nonatomic, retain) AVAudioPlayer *player;

@end

@implementation MCommentDialogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.messageSender = @"WatchAPP";
//    self.messageTableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self.messageTableView setHidden:YES];
    
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
    
    UIButton *buton = [[UIButton alloc] init];
    buton.tag = 2;
    [self closePopView:buton];

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

@end
