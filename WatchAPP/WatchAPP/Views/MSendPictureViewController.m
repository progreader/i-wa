//
//  MSendPictureViewController.m
//  WatchAPP
//
//  Created by Mike Mai on 7/1/14.
//  Copyright (c) 2014 mSquare. All rights reserved.
//

#import "MSendPictureViewController.h"
#import "GCPlaceholderTextView.h"
#import "MPhotoPickerDialogViewController.h"
#import "MOk2DialogViewController.h"
#import "MNewHomeResourceService.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface MSendPictureViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ServiceCallback>

@property (nonatomic, strong) IBOutlet GCPlaceholderTextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *pickButton;

@property(nonatomic,strong)MNewHomeResourceService *createHomeResourceService;

@end

@implementation MSendPictureViewController

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
    
    self.createHomeResourceService = [[MNewHomeResourceService alloc] initWithSid:@"MNewHomeResourceService" andCallback:self];
    
    if(self.pickedImage)
    {
        [self.pickButton setImage:self.pickedImage forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didOnSendButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    
    NSData* imageData=UIImageJPEGRepresentation(self.pickedImage,0.65);
    NSString* content=self.textView.text;
    
    if(!imageData && content.length==0)
    {
        return;
    }
    
    [self.createHomeResourceService requestHomeResourceNewByUpImageData:imageData content:content];
}

- (void)callbackWithResult:(ServiceResult *)result forSid:(NSString *)sid
{
    NSString* msg=@"发送成功";
    
    if(result.hasError)
    {
        msg=@"发送失败";
    }
    
    MOk2DialogViewController *viewController = [MOk2DialogViewController new];
    viewController.message = msg;
    viewController.mj_dismissDelegate = self;
    
    [self presentPopupViewController:viewController animationType:MJPopupViewAnimationSlideBottomBottom isBackgroundClickable:NO dismissed:^{
            
            if(!result.hasError)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
}

- (IBAction)didOnAddHeaderButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    MPhotoPickerDialogViewController *viewController = [MPhotoPickerDialogViewController new];
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
            default:
                break;
        }
    }];
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
    
    self.pickedImage=image;
    [self.pickButton setImage:image forState:UIControlStateNormal];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage*)imageFromImagePickerMediaInfo:(NSDictionary*)info
{
    UIImage* image=nil;
    
    NSString* mediaType=[info objectForKey:UIImagePickerControllerMediaType];
	if([mediaType isEqualToString:(NSString*)kUTTypeImage])//(NSString*)kUTTypeImage,public.image
	{
		image=[info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    
    return image;
}

@end
