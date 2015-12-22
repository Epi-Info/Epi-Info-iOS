//
//  SampleSizeAndPowerViewController.h
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//

#import "BlurryView.h"
#import <UIKit/UIKit.h>

@interface SampleSizeAndPowerViewController : UIViewController
{
    BOOL currentOrientationPortrait;
    
    UIImageView *fadingColorView;
    
    CGRect button1Frame;
    CGRect button2Frame;
    CGRect button3Frame;
    CGRect button1LandscapeFrame;
    CGRect button2LandscapeFrame;
    CGRect button3LandscapeFrame;
    
    UIImageView *cdcImageView;
    UIImageView *hhsImageView;
    
    BlurryView *blurryView;
    
    CGRect frameOfButtonPressed;
    UIButton *buttonPressed;
    
    NSString *imageFileToUseInSegue;
}
@property (weak, nonatomic) IBOutlet UIButton *unmatchedCaseControlButton;
@property (weak, nonatomic) IBOutlet UIButton *cohortButton;
@property (weak, nonatomic) IBOutlet UIButton *populationSurveyButton;

-(BlurryView *)blurryView;
-(CGRect)frameOfButtonPressed;
-(UIButton *)buttonPressed;
-(NSString *)imageFileToUseInSegue;
@end
