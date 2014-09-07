//   tao 

#import "amrup.h"

#import "wav.h"
@implementation amrdl

/**
 *	生成当前时间字符串
 *	@return	当前时间字符串
 */
+ (NSString *)currentTimeString
{
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

/**
 *	获取amr音频文件保存的路径
 *	@return	amr音频文件保存的路径
 */
+ (NSString *)voiceDocumentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Voice"];
}

/**
 *	获取音频文件缓存路径
 *	@return	音频文件缓存路径
 */
+ (NSString *)voiceCacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0]stringByAppendingPathComponent:@"Voice"];
}

/**
 判断文件是否存在
 @param _path 文件路径
 @returns 存在返回yes
 */
+ (BOOL)fileExistsAtPath:(NSString *)aPath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:aPath];
}

/**
 删除文件
 @param _path 文件路径
 @returns 成功返回yes
 */
+ (BOOL)deleteFileAtPath:(NSString *)aPath
{
    return [[NSFileManager defaultManager] removeItemAtPath:aPath error:nil];
}

/**
 *	开始录音
 *	@param 	aFileName  录音音频文件名
 *	@return	void
 */
- (void)beginRecordByFileName:(NSString *)aFileName
{
    _wavNewPath = [[NSString alloc] initWithFormat:@"%@%@new.wav", [amrdl voiceDocumentDirectory], aFileName];
    _amrPath = [[NSString alloc] initWithFormat:@"%@%@.amr", [amrdl voiceDocumentDirectory], aFileName];
    NSString *path = [[NSString alloc] initWithFormat:@"%@%@.wav", [amrdl voiceDocumentDirectory], aFileName];
    _path = path;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:path]
                                                settings:[amrdl audioRecorderSettingDict]
                                                   error:nil];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self.recorder record];
}

//停止录音
- (void)stopRecord
{
    if (self.recorder.isRecording)
        [self.recorder stop];
}

- (void)playRecordByPath:(NSString *)aPath
{
    _player = [[AVAudioPlayer alloc] init];
    _player = [_player initWithContentsOfURL:[NSURL URLWithString:aPath] error:nil];
    [_player play];
}

/**
 获取录音设置
 [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
 [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
 [NSNumber numberWithInt: AVAudioQualityLow],AVEncoderAudioQualityKey,//音频编码质量
 @returns 录音设置
 */
+ (NSDictionary*)audioRecorderSettingDict
{
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   nil];
    return recordSetting;
}

/**
 *	根据文件路径获取文件大小
 *	@param 	aFilePath 	文件路径
 *	@return	文件大小
 */
- (NSInteger)sizeOfFileFromPath:(NSString *)aFilePath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:aFilePath]) {
        NSError *error = nil;
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:aFilePath error:&error];
        NSNumber *fileSize;
        if ((fileSize = [attributes objectForKey:NSFileSize])) {
            return [fileSize intValue];
        } else {
            return -1;
        }
    } else {
        return -1;
    }
}





/**
 *	amr格式转换成wav
 *	@param 	aSavePath 	转成wav后保存的路径
 *	@return	是否转换成功
 */
+ (BOOL)amrToWav:(NSString*)aAmrPath savePath:(NSString*)aSavePath
{
    if (DecodeAMRFileToWAVEFile([aAmrPath cStringUsingEncoding:NSASCIIStringEncoding], [aSavePath cStringUsingEncoding:NSASCIIStringEncoding]))
        return YES;
    
    return NO;
}

/**
 *	wav格式转换成amr
 *	@param 	aSavePath 	转成amr后保存的路径
 *	@return	是否转换成功
 */
+ (BOOL)wavToAmr:(NSString*)aWavPath savePath:(NSString*)aSavePath
{
    if (EncodeWAVEFileToAMRFile([aWavPath cStringUsingEncoding:NSASCIIStringEncoding], [aSavePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
        return YES;
    
    return NO;
}





#pragma mark -
#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"录音停止");
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    NSLog(@"录音开始");
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
    NSLog(@"录音中断");
}


@end
