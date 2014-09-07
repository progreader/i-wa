//
//  MSendTextViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MSendTextViewController.h"
#import "GCPlaceholderTextView.h"
#import "MOk2DialogViewController.h"
#import "MNewHomeResourceService.h"

@interface MSendTextViewController ()<ServiceCallback>

@property (nonatomic, strong) IBOutlet GCPlaceholderTextView *textView;

@property(nonatomic,strong)MNewHomeResourceService *createHomeResourceService;

@end

@implementation MSendTextViewController

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
    self.textView.placeholderColor = [UIColor lightGrayColor];
    self.textView.placeholder = @"此刻你的想法...";
    
    CALayer *layer = [self.textView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0];
    [layer setBorderWidth:0.5];
    [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    self.createHomeResourceService = [[MNewHomeResourceService alloc] initWithSid:@"MNewHomeResourceService" andCallback:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnSendButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    
    NSString* content=self.textView.text;
    
    [self.createHomeResourceService requestHomeResourceNewByUpImageData:nil content:content];
}

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    BOOL success=[[result.data objectForKey:@"success"] intValue]==1;
    
    NSString* msg=success?@"发送成功":@"发送失败";
    
    MOk2DialogViewController *viewController = [MOk2DialogViewController new];
    viewController.message = msg;
    viewController.mj_dismissDelegate = self;
    
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
        
        if(success)
        {
            [self.navigationController popViewControllerAnimated:YES];
            
            [_delegate handleSendSuccess];
        }
    }];
}

@end
