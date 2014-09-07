#import <UIKit/UIKit.h>
#import "amrup.h"

@interface amrdlview : UIViewController <UIGestureRecognizerDelegate>  //自定义 amrdlview
{
    amrdl *_amrdl;
}


//以下随意按钮仅用于测试.

@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (weak, nonatomic) IBOutlet UIButton *playWavButtonTap;

@property (weak, nonatomic) IBOutlet UILabel *wavInfoLabel;

- (IBAction)playWav:(id)sender;
- (IBAction)wavToAmr:(id)sender;
- (IBAction)amrToWav:(id)sender;
- (IBAction)playNewWav:(id)sender;

@end
