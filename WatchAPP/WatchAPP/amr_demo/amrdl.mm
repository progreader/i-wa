#import "amrdl.h"

@interface amrdl ()

@end

@implementation amrdlview

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _amrdl = [[amrdl alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(recordButtonLongPress:)];
    longPress.delegate = self;
    [_recordButton addGestureRecognizer:longPress];
    
}

//录音调用方法
- (void)recordButtonLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        //录音开始.
        [_amrdl beginRecordByFileName:[amrdl currentTimeString]];
    } else if (longPress.state == UIGestureRecognizerStateEnded) {
        //结束.
        [_amrdl stopRecord];
        NSString *wavInfoStr = [NSString stringWithFormat:@"文件大小:%d", [_amrdl sizeOfFileFromPath:_amrdl.path] / 1024];
        _wavInfoLabel.text = wavInfoStr;
        
    }
}

//播放录音
- (IBAction)playWav:(id)sender {
    [_amrdl playRecordByPath:_amrdl.path];
}



// 调用转换后的amr并上传
- (IBAction)wavToAmr:(id)sender {
    
    BOOL isSuccess = [amrdl wavToAmr:_amrdl.path savePath:_amrdl.amrPath];
    if (isSuccess) {
        NSLog(@"convert wav to amr success!");
    } else
        NSLog(@"covert wav to amr fail!");
    
    
    
    /*
    //开始上传 _amrdl.path
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:@"%.amr"];
    NSData *webData = [NSData dataWithContentsOfURL:documentsURL];
    NSString *myUrlString=@"URL";
    NSURL *myURL = [NSURL URLWithString:myUrlString];
    
    NSLog(@"Send messageurl = %@ ",myURL);
    
    if ([myUrlString isEqualToString:@"ENTER YOUR URL"]) {
       
                       }
        else
                 {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:myURL];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[NSData dataWithData:webData]];
        [request setHTTPBody:body];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if([(NSHTTPURLResponse *)response statusCode]==200)
             {
                 
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                 NSLog(@"Upload status=%@",jsonObject);
               
             }
         }];
        
        
    }
    */
    
}




//下载amr开始转换为wav
- (IBAction)amrToWav:(id)sender {
    
    
    BOOL isSuccess = [amrdl amrToWav:_amrdl.amrPath savePath:_amrdl.wavNewPath];
    if (isSuccess) {
        NSLog(@"convert amr to wav success!");
    } else {
        NSLog(@"convert amr to wav fail!");
    }
    

}

//播放转后的wav
- (IBAction)playNewWav:(id)sender {
    [_amrdl playRecordByPath:_amrdl.wavNewPath];

}

@end
