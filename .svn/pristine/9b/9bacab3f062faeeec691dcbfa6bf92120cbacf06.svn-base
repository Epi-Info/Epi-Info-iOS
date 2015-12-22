//
//  MatchedPairCalculatorViewController.h
//  MatchedPairCalculator
//
//  Created by John Copeland on 10/1/12.
//

#import "ZoomView.h"
#import "BlurryView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MatchedPairCalculatorViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *customBackButton;
    
    BOOL currentOrientationPortrait;
    
    BOOL fourInchPhone;
    
    NSThread *workerThread;
    UIView *hiderView;
    
    CGRect scrollViewFrame;
    UIImageView *fadingColorView;
    
    CGRect computingFrame;
    
    ZoomView *zoomingView;
    UIView *phoneInputsView;
    UIView *phoneOddsBasedParametersView;
    UIView *phoneStatisticalTestsView;
    
    UIView *phoneInputsColorBox;
    float phoneInputsColorBoxBorder;
    
    UIView *phoneOddsBasedParametersColorBox;
    UIView *phoneOBPWhiteBox1;
    UIView *phoneOBPWhiteBox2;
    UIView *phoneOBPWhiteBox3;
    UIView *phoneOBPWhiteBox4;
    UIView *phoneOBPWhiteBox5;
    UIView *phoneOBPWhiteBox6;
    UIView *phoneOBPWhiteBox7;
    UIView *phoneOBPWhiteBox8;
    UIView *phoneOBPWhiteBox9;
    UIView *phoneOBPWhiteBox10;
    UIView *phoneOBPWhiteBox11;
    UIView *phoneOBPWhiteBox12;
    UIView *phoneOBPExtraWhite1;
    UIView *phoneOBPExtraWhite2;
    UIView *phoneOBPExtraWhite3;
    UIView *phoneOBPExtraWhite4;
    
    UIView *phoneStatisticalTestsColorBox;
    UIView *phoneSTWhiteBox1;
    UIView *phoneSTWhiteBox2;
    UIView *phoneSTWhiteBox3;
    UIView *phoneSTWhiteBox4;
    UIView *phoneSTWhiteBox5;
    UIView *phoneSTWhiteBox6;
    UIView *phoneSTWhiteBox7;
    UIView *phoneSTWhiteBox8;
    UIView *phoneSTWhiteBox9;
    UIView *phoneSTWhiteBox10;
    UIView *phoneSTWhiteBox11;
    UIView *phoneSTWhiteBox12;
    UIView *phoneSTWhiteBox13;
    UIView *phoneSTWhiteBox14;
    UIView *phoneSTWhiteBox15;
    UIView *phoneSTExtraWhite1;
    UIView *phoneSTExtraWhite2;
    UIView *phoneSTExtraWhite3;
    UIView *phoneSTExtraWhite4;
    
    UIView *phoneDisclaimersView;
    UIView *phoneDisclaimersColorBox;
    UIView *phoneDisclaimersWhiteBox;
    
    BlurryView *blurryView;
}

@property (copy, nonatomic) NSString *yyString;
@property (copy, nonatomic) NSString *ynString;
@property (copy, nonatomic) NSString *nyString;
@property (copy, nonatomic) NSString *nnString;

@property (weak, nonatomic) IBOutlet UILabel *phoneControlsLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneCasesLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneCasesPlusLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneCasesMinusLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneControlsPlusLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneControlsMinusLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneOddsBasedSectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneEstimateLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneUpperLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneOddsRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneExactLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneStatisticalTestsSectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneX2Label;
@property (weak, nonatomic) IBOutlet UILabel *phoneX2PLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneMcNemarLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneCorrectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone1TailedPLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone2TailedPLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneFisherExactLabel;
@property (weak, nonatomic) IBOutlet UITextField *yyField;
@property (weak, nonatomic) IBOutlet UITextField *ynField;
@property (weak, nonatomic) IBOutlet UITextField *nyField;
@property (weak, nonatomic) IBOutlet UITextField *nnField;
@property (weak, nonatomic) IBOutlet UILabel *orEstimate;
@property (weak, nonatomic) IBOutlet UILabel *orLower;
@property (weak, nonatomic) IBOutlet UILabel *orUpper;
@property (weak, nonatomic) IBOutlet UILabel *fisherLower;
@property (weak, nonatomic) IBOutlet UILabel *fisherUpper;
@property (weak, nonatomic) IBOutlet UILabel *uX2;
@property (weak, nonatomic) IBOutlet UILabel *uX2P;
@property (weak, nonatomic) IBOutlet UILabel *cX2;
@property (weak, nonatomic) IBOutlet UILabel *cX2P;
@property (weak, nonatomic) IBOutlet UILabel *fisherExact;
@property (weak, nonatomic) IBOutlet UILabel *fisherExact2;
@property (weak, nonatomic) IBOutlet UILabel *exactLimitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *exactTestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneTailedPLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoTailedPLabel;
@property (weak, nonatomic) IBOutlet UILabel *discordantPairLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellAdditionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *computing;

@property (weak, nonatomic) IBOutlet UIScrollView *epiInfoScrollView0;
@property (weak, nonatomic) IBOutlet UINavigationBar *lowerNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *subView1;
@property (weak, nonatomic) IBOutlet UIView *subView2;

- (IBAction)compute:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)textFieldAction:(id)sender;
- (IBAction)resetBarButtonPressed:(id)sender;

@end
