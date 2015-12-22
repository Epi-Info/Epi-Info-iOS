//
//  CohortSampleSizeViewController.h
//  EpiInfo
//
//  Created by John Copeland on 10/10/12.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ZoomView.h"
#import "ButtonRight.h"
#import "ButtonLeft.h"

@interface CohortSampleSizeViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *customBackButton;
    
    BOOL fourInchPhone;
    
    BOOL currentOrientationPortrait;
    
    BOOL hasAFirstResponder;
    
    CGRect scrollViewFrame;
    UIImageView *fadingColorView;
    UIImageView *fadingColorView0;
    
    //iPhone-specific layout views and frames
    ZoomView *zoomingView;
    UIView *phoneOddsRatioView;
    UIView *phoneOddsRatioViewWhiteBox;
    UIView *phoneOddsRatioViewExtraWhite;
    UIView *phoneRiskRatioView;
    UIView *phoneRiskRatioViewWhiteBox;
    UIView *phoneRiskRatioViewExtraWhite;
    UIView *phoneResultsView;
    UIView *phoneResultsWhitebox1;
    UIView *phoneResultsWhitebox2;
    UIView *phoneResultsWhitebox3;
    UIView *phoneResultsWhitebox4;
    UIView *phoneResultsWhitebox5;
    UIView *phoneResultsWhitebox6;
    UIView *phoneResultsWhitebox7;
    UIView *phoneResultsWhitebox8;
    UIView *phoneResultsWhitebox9;
    UIView *phoneResultsExtraWhite1;
    UIView *phoneResultsExtraWhite2;
    
    ButtonLeft *blPower;
    ButtonRight *brPower;
    ButtonLeft *blUnexposed;
    ButtonRight *brUnexposed;
    ButtonLeft *blExposed;
    ButtonRight *brExposed;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneConfidenceLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneConfidenceLevelValue;
@property (weak, nonatomic) IBOutlet UILabel *phonePowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *phonePowerPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneControlsOrUnexposedLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneControlsOrUnexposedPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneCasesOrExposedLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneCasesOrExposedPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneOddsRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneRiskRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneKelseyLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneFleissLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneFleissWithCCLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneExposedOrCasesResultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneUnexposedOrControlsResultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneTotalResultsLabel;

@property (weak, nonatomic) IBOutlet UITextField *powerField;
@property (weak, nonatomic) IBOutlet UITextField *ratioField;
@property (weak, nonatomic) IBOutlet UITextField *unexposedField;
@property (weak, nonatomic) IBOutlet UILabel *riskRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioLabel;
@property (weak, nonatomic) IBOutlet UITextField *exposedField;
@property (weak, nonatomic) IBOutlet UILabel *exposedKelseyLabel;
@property (weak, nonatomic) IBOutlet UILabel *exposedFleissLabel;
@property (weak, nonatomic) IBOutlet UILabel *exposedFleissCCLabel;
@property (weak, nonatomic) IBOutlet UILabel *unexposedKelseyLabel;
@property (weak, nonatomic) IBOutlet UILabel *unexposedFleissLabel;
@property (weak, nonatomic) IBOutlet UILabel *unexposedFleissCCLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalKelseyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFleissLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFleissCCLabel;
- (IBAction)compute:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)resetBarButtonPressed:(id)sender;

//for Ipad
@property (nonatomic,retain) IBOutlet UITextField *sliderLabel1;
@property (nonatomic,retain) IBOutlet UITextField *sliderLabel2;
@property (nonatomic,retain) IBOutlet UITextField *sliderLabel3;
@property (weak, nonatomic) IBOutlet UISlider *powerSlider;
@property (weak, nonatomic) IBOutlet UIStepper *powerStepper;
@property (weak, nonatomic) IBOutlet UISlider *unexposedSlider;
@property (weak, nonatomic) IBOutlet UIStepper *unexposedStepper;
@property (weak, nonatomic) IBOutlet UISlider *exposedSlider;
@property (weak, nonatomic) IBOutlet UIStepper *exposedStepper;
@property (weak, nonatomic) IBOutlet UIScrollView *epiInfoScrollView0;
@property (weak, nonatomic) IBOutlet UINavigationBar *lowerNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *subView1;
@property (weak, nonatomic) IBOutlet UIView *subView2;
@property (weak, nonatomic) IBOutlet UIView *subView3;

-(IBAction) sliderChanged1:(id) sender;
-(IBAction) sliderChanged2:(id) sender;
-(IBAction) sliderChanged3:(id) sender;
- (IBAction)stepperChanged1:(id)sender;
- (IBAction)stepperChanged2:(id)sender;
- (IBAction)stepperChanged3:(id)sender;
- (IBAction)textFieldAction:(id)sender;
- (IBAction)textFieldBecameFirstResponder:(id)sender;
//
@end
