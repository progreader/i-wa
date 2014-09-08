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
#import  "MRequestMessageList.h"
#import "amrdl.h"
#import "XHMessageTableViewCell.h"
#import "XHVoiceCommonHelper.h"
#import "MRequestNewPageService.h"
#import "MRequestPageListService.h"
@interface MChatViewController ()<XHMessageTableViewCellDelegate,AVAudioPlayerDelegate,AVAudioSessionDelegate,ServiceCallback>

@property (nonatomic, strong) NSArray *emotionManagers;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, strong) IBOutlet UILabel *chatTitleLabel;
@property(nonatomic,strong)MUploadMessageService *uploadMessageService;
@property(nonatomic,strong)MRequestMessageList *requestMessageList;
@property(nonatomic,strong)MRequestNewPageService *requestNewPageService;
@property(nonatomic,strong)MRequestPageListService *requestPageListService;
@property(nonatomic,strong)NSString *wavPath;
@end

@implementation MChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.messageSender = @"WatchAPP";
    self.chatTitleLabel.text = self.chatTitle;
    self.title=self.chatTitle;
    
    //谷少鹏 0905 初始化消息服务类
    self.uploadMessageService = [[MUploadMessageService alloc] initWithSid:@"MUploadMessageService" andCallback:self];
    self.requestMessageList=[[MRequestMessageList alloc] initWithSid:@"MRequestMessageList" andCallback:self];
    self.requestNewPageService=[[MRequestNewPageService alloc] initWithSid:@"MRequestNewPageService" andCallback:self];
    self.requestPageListService=[[MRequestPageListService alloc]initWithSid:@"MRequestPageListService" andCallback:self];
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
    [self footerBeginRefreshing];
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

            NSString *voicePath=message.voicePath;
            NSString *voiceUrl=message.voiceUrl;
           
            if(voicePath==nil){
                voicePath=[self getVoicePathAmrFileName:[voiceUrl lastPathComponent]];
                
                if(![XHVoiceCommonHelper fileExistsAtPath:[voicePath stringByAppendingPathExtension:@"wav"]]){
                    [self convertAmr2WavByUrl:voiceUrl SavePath:voicePath];
                }
                voicePath=[voicePath stringByAppendingPathExtension:@"wav"];
            }
            if(self.player==nil){
                 self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:voicePath] error:nil];
            }
            else
            {
                if([self.player isPlaying])
                {
                    [self.player stop];
                }
                [self.player initWithContentsOfURL:[NSURL URLWithString:voicePath] error:nil];
            }
           
            self.player.volume = 1.0f;
           
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
-(void)loadMoreMessagesScrollTotop{
    self.loadingMoreMessage=YES;
    if([self.memberDataItem[@"TYPE"] isEqualToString:@"MEMBER"]){
       [self.requestMessageList requestMessageListByPage:[NSNumber numberWithInt:1]];
    }
    else if([self.memberDataItem[@"TYPE"] isEqualToString:@"GROUP"] ){
        [self.requestPageListService requestPageListByPage:[NSNumber numberWithInt:1]];
    }
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
    NSString *wavPath=[[voicePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:wavPath voiceUrl:nil voiceDuration:voiceDuration sender:sender timestamp:date];
    voiceMessage.bubbleMessageType = XHBubbleMessageTypeSending;
//    voiceMessage.avator = [UIImage imageNamed:@"头像"];
    NSString *avatarUrl=[MAppDelegate sharedAppDelegate].loginData[@"obj"][@"avatar_url"];
    voiceMessage.avatorUrl = [[MRequestMessageList getBaseUrl] stringByAppendingString:avatarUrl];
    [self addMessage:voiceMessage];
    
    //谷少鹏 0905 将amr文件上传到服务器*****
    if([self.memberDataItem[@"TYPE"] isEqualToString:@"MEMBER"]){
        [self.uploadMessageService requestMessageNewByUpfile:voicePath recipient:self.memberDataItem[@"OID"]];
    }
    else if([self.memberDataItem[@"TYPE"] isEqualToString:@"GROUP"] ){
        [self.requestNewPageService requestNewPageByUpfile:voicePath subject:@"组语音"] ;
    }

    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
}
//谷少鹏0907将服务器上获取的语音加到语音列表
-(void) addMessageFromServer:(NSArray *)messages{
    NSMutableArray *messageArray=[[NSMutableArray alloc]init];
    NSString *loginOID=[MAppDelegate sharedAppDelegate].loginData[@"obj"][@"_id"][@"$oid"];
    NSString *memberOID=self.memberDataItem[@"OID"];
    for (int i=messages.count-1; i>-1; i--) {
        NSDictionary *message=messages[i];
        NSString *messageCls=message[@"_cls"];
        NSInteger mediaType=[message[@"media_type"] integerValue];
        
        BOOL isAmrFile=NO;
        if([messageCls isEqualToString:@"Message.MediaMessage"] && 1==mediaType) isAmrFile=YES;
        if([messageCls isEqualToString:@"Page.MediaPage"] && 0==mediaType) isAmrFile=YES;
        if(isAmrFile==NO) continue;
        NSString *extend=[message[@"url"] pathExtension];
        if([extend isEqualToString:@"amr"]==NO) continue;
        NSString *amrUrl= [[MRequestMessageList getBaseUrl] stringByAppendingString:message[@"url"]];
        NSInteger amrLength=[message[@"media_length"] integerValue];
        NSString *voiceDuration=[[NSString alloc] initWithFormat:@"%d",(amrLength/1000)];
        double dateLong=[message[@"created_at"][@"$date"] doubleValue]/1000-8*60*60;
        NSDate *sendDate=[[NSDate alloc] initWithTimeIntervalSince1970:dateLong];
        NSString *avatarUrl=nil;
        XHMessage *voiceMessage=[[XHMessage alloc]initWithVoicePath:nil voiceUrl:amrUrl voiceDuration:voiceDuration sender:@"home" timestamp:sendDate];
        
        //用户语音的处理
        if([self.memberDataItem[@"TYPE"] isEqualToString:@"MEMBER"]){
            BOOL recipient_deleted=[message[@"recipient_deleted"] boolValue];
            BOOL sender_deleted=[message[@"sender_deleted"] boolValue];
            if(recipient_deleted || sender_deleted) continue;
            NSString *senderOID=message[@"sender"][@"$oid"];
            NSString *recipientOID=message[@"recipient"][@"$oid"];
            if([senderOID isEqualToString:loginOID]){
                if([recipientOID isEqualToString:memberOID]){
                    voiceMessage.bubbleMessageType = XHBubbleMessageTypeSending;
                    avatarUrl=message[@"$sender"][@"avatar_url"];
                }
                else continue;
            }
            else if([senderOID isEqualToString:memberOID])
            {
                if([recipientOID isEqualToString:loginOID]){
                    voiceMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
                    avatarUrl=message[@"$recipient"][@"avatar_url"];
                }else continue;
                
            }else continue;
        //群语音的处理
        }else if([self.memberDataItem[@"TYPE"] isEqualToString:@"GROUP"]){
            NSString *createdBy=message[@"created_by"][@"$oid"];
            if([createdBy isEqualToString:loginOID]){
                voiceMessage.bubbleMessageType = XHBubbleMessageTypeSending;
            }else{
                voiceMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
            }
            avatarUrl=message[@"$created_by"][@"avatar_url"];
        }
        avatarUrl=[[MRequestMessageList getBaseUrl] stringByAppendingString:avatarUrl];
        NSData *imageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:avatarUrl]];
        UIImage *avatarImage=[[UIImage alloc]initWithData:imageData];
        voiceMessage.avator=avatarImage;
        [messageArray addObject:voiceMessage];
    }
    [self.messages removeAllObjects];
    [self.messageTableView reloadData];
    [self insertOldMessages:messageArray];
    self.loadingMoreMessage=NO;
    [self footerEndRefreshing];
    
    
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
    NSLog(@"播放完成");
}

//谷少鹏 0905 消息服务回调
- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    if ([sid isEqualToString:@"MUploadMessageService"]) {
          NSLog(@"%@", result.data);
    }
    else if([sid isEqualToString:@"MRequestMessageList"]){
        NSArray *messageList=result.data[@"objs"];
        [self addMessageFromServer:messageList];
    }
    else if([sid isEqualToString:@"MRequestNewPageService"]){
        NSLog(@"%@", result.data);
    }
    else if([sid isEqualToString:@"MRequestPageListService"]){
        NSArray *messageList=result.data[@"objs"];
        [self addMessageFromServer:messageList];
    }
}

-(NSString *)getVoicePathAmrFileName:(NSString *)amrFileName{
    NSString *voicePath=[[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    voicePath=[voicePath stringByAppendingPathComponent:self.memberDataItem[@"OID"]];
     BOOL isDir=YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:voicePath isDirectory:&isDir] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *voiceFileName=[amrFileName stringByDeletingPathExtension];
    voicePath=[voicePath stringByAppendingPathComponent:voiceFileName];
    return voicePath;
}
-(BOOL)convertAmr2WavByUrl:(NSString *)amrUrl SavePath:(NSString *)path{
    NSData *amrData=[NSData dataWithContentsOfURL:[NSURL URLWithString:amrUrl]];
    NSString *amrPath=[path stringByAppendingPathExtension:@"amr"];
    NSString *floderPath=[path stringByDeletingLastPathComponent];
    BOOL result=NO;
    BOOL isDir=YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:floderPath isDirectory:&isDir] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:floderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [amrData writeToFile:amrPath atomically:NO];
    result= ([amrdl amrToWav:amrPath savePath:[path stringByAppendingPathExtension:@"wav"]]);

    return result;
}
@end
