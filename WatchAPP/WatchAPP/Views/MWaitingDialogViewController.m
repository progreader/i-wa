//
//  MOkDialogViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 6/28/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MWaitingDialogViewController.h"

@interface MWaitingDialogViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) NSTimer *autoCloseCountDownTimer;

@end

@implementation MWaitingDialogViewController

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
    [self.messageLabel setText:self.message];
    
    if (self.autoCloseCountDownSecond > 0) {
        self.autoCloseCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoCloseCountDownSecond target:self selector:@selector(timeFireForAutoClose) userInfo:nil repeats:YES];
        [self.autoCloseCountDownTimer fire];
    }
}

-(void)setWaitingMessage:(NSString *)message
{
    [self.messageLabel setText:message];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timeFireForAutoClose
{
    if (0 == self.autoCloseCountDownSecond) {
        [self.autoCloseCountDownTimer invalidate];
        self.autoCloseCountDownTimer = nil;
        [self closeTheDialog];
    } else {
        self.autoCloseCountDownSecond -= 1;
    }
}

- (void)closeTheDialog
{
    UIButton *sender = [[UIButton alloc] init];
    sender.tag = 2;
    [self closePopView:sender];
}

@end
