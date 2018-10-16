//
//  StatCalc2x2ViewController.h
//  StatCalc2x2
//
//  Created by John Copeland on 9/7/12.
//

#import "Twox2CalculatorView.h"
#import "ZoomView.h"
#import "BlurryView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface StatCalc2x2ViewController : UIViewController <UIApplicationDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
//    int stratum;
    UIButton *customBackButton;
    
    BOOL currentOrientationPortrait;
    
    BOOL fourInchPhone;
    
    NSThread *workerThread;
    NSThread *timeConsumingCrudeThread;
    NSArray *strataData;
    UILabel *adjustedMHLabel;
    UILabel *adjustedMLELabel;
    UILabel *adjustedMHEstimate;
    UILabel *adjustedMHLower;
    UILabel *adjustedMHUpper;
    UILabel *adjustedMLEEstimate;
    UILabel *adjustedMLELower;
    UILabel *adjustedMLEUpper;
    UISegmentedControl *segmentedControl;
    
    CGRect scrollViewFrame;
    UIImageView *fadingColorView;
    UIImageView *fadingColorView0;
    
    CGRect computingFrame;
    
    int summaryTabLines;
    NSLineBreakMode summaryTabMode;
    CGRect summaryTabFrame;
    
    ZoomView *zoomingView;
    
    UIView *phoneInputsView;
    UIView *phoneOddsBasedParametersView;
    UIView *phoneRiskBasedParametersView;
    UIView *phoneStatisticalTestsView;
    
    CGRect phoneOutcomeLabelFrame;
    CGRect phoneExposureLabelFrame;
    CGRect phoneYYFieldFrame;
    CGRect phoneYNFieldFrame;
    CGRect phoneNYFieldFrame;
    CGRect phoneNNFieldFrame;
    
    CGRect phoneOddsBasedParametersLabelFrame;
    CGRect phoneOREstimateLabelFrame;
    CGRect phoneORLowerLabelFrame;
    CGRect phoneORUpperLabelFrame;
    CGRect phoneOddsRatioLabelFrame;
    CGRect phoneOREstimateFrame;
    CGRect phoneORLowerFrame;
    CGRect phoneORUpperFrame;
    CGRect phoneMLEORLabelFrame;
    CGRect phoneMLEORFrame;
    CGRect phoneMLELowerFrame;
    CGRect phoneMLEUpperFrame;
    CGRect phoneFisherExactCILabelFrame;
    CGRect phoneFisherLowerFrame;
    CGRect phoneFisherUpperFrame;
    CGRect phoneAdjustedMHLabelFrame;
    CGRect phoneAdjustedMHEstimateFrame;
    CGRect phoneAdjustedMHLowerFrame;
    CGRect phoneAdjustedMHUpperFrame;
    CGRect phoneAdjustedMLELabelFrame;
    CGRect phoneAdjustedMLEEstimateFrame;
    CGRect phoneAdjustedMLELowerFrame;
    CGRect phoneAdjustedMLEUpperFrame;
    
    CGRect phoneRiskBasedParametersLabelFrame;
    CGRect phoneRiskEstimateLabelFrame;
    CGRect phoneRiskLowerLabelFrame;
    CGRect phoneRiskUpperLabelFrame;
    CGRect phoneRelativeRiskLabelFrame;
    CGRect phoneRREstimateFrame;
    CGRect phoneRRLowerFrame;
    CGRect phoneRRUpperFrame;
    CGRect phoneRiskDifferenceLabelFrame;
    CGRect phoneRDEstimateFrame;
    CGRect phoneRDLowerFrame;
    CGRect phoneRDUpperFrame;
    
    CGRect phoneStatisticalTestsLabelFrame;
    CGRect phoneX2LabelFrame;
    CGRect phoneX2PLabelFrame;
    CGRect phoneUncorrectedLabelFrame;
    CGRect phoneUX2Frame;
    CGRect phoneUX2PFrame;
    CGRect phoneMantelHaenszelLabelFrame;
    CGRect phoneMHX2Frame;
    CGRect phoneMHX2PFrame;
    CGRect phoneCorrectedLabelFrame;
    CGRect phoneCX2Frame;
    CGRect phoneCX2PFrame;
    CGRect phone1TailedPLabelFrame;
    CGRect phone2TailedPLabelFrame;
    CGRect phoneMidPExactLabelFrame;
    CGRect phoneMPExactFrame;
    CGRect phoneFisherExactTestLabelFrame;
    CGRect phoneFisherExactFrame;
    CGRect phoneFisherExact2Frame;

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
    UIView *phoneOBPWhiteBox13;
    UIView *phoneOBPWhiteBox14;
    UIView *phoneOBPWhiteBox15;
    UIView *phoneOBPWhiteBox16;
    UIView *phoneOBPWhiteBox17;
    UIView *phoneOBPWhiteBox18;
    UIView *phoneOBPWhiteBox19;
    UIView *phoneOBPWhiteBox20;
    UIView *phoneOBPWhiteBox21;
    UIView *phoneOBPWhiteBox22;
    UIView *phoneOBPWhiteBox23;
    UIView *phoneOBPWhiteBox24;
    UIView *phoneOBPExtraWhite1;
    UIView *phoneOBPExtraWhite2;
    UIView *phoneOBPExtraWhite3;
    UIView *phoneOBPExtraWhite4;
    UIView *phoneOBPBottomRow;
    CGRect phoneOBPBottomRowFrame1;
    CGRect phoneOBPBottomRowFrame2;

    UIView *phoneRiskBasedParametersColorBox;
    UIView *phoneRBPWhiteBox1;
    UIView *phoneRBPWhiteBox2;
    UIView *phoneRBPWhiteBox3;
    UIView *phoneRBPWhiteBox4;
    UIView *phoneRBPWhiteBox5;
    UIView *phoneRBPWhiteBox6;
    UIView *phoneRBPWhiteBox7;
    UIView *phoneRBPWhiteBox8;
    UIView *phoneRBPWhiteBox9;
    UIView *phoneRBPWhiteBox10;
    UIView *phoneRBPWhiteBox11;
    UIView *phoneRBPWhiteBox12;
    UIView *phoneRBPExtraWhite1;
    UIView *phoneRBPExtraWhite2;
    UIView *phoneRBPExtraWhite3;
    UIView *phoneRBPExtraWhite4;

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
    UIView *phoneSTWhiteBox16;
    UIView *phoneSTWhiteBox17;
    UIView *phoneSTWhiteBox18;
    UIView *phoneSTWhiteBox19;
    UIView *phoneSTWhiteBox20;
    UIView *phoneSTWhiteBox21;
    UIView *phoneSTExtraWhite1;
    UIView *phoneSTExtraWhite2;
    UIView *phoneSTExtraWhite3;
    UIView *phoneSTExtraWhite4;
    UIView *phoneSTBottomRow;
    CGRect phoneSTBottomRowFrame1;
    CGRect phoneSTBottomRowFrame2;
    
    CGRect fisherExactLabelFrame;
    CGRect fisherExact1Frame;
    CGRect fisherExact2Frame;
    CGRect twoTailedPLabelFrame;
    
    BlurryView *blurryView;
    
    NSThread *exactThread;
}
@property int stratum;
@property (copy, nonatomic) NSString *yyString;
@property (copy, nonatomic) NSString *ynString;
@property (copy, nonatomic) NSString *nyString;
@property (copy, nonatomic) NSString *nnString;

@property (weak, nonatomic) IBOutlet UILabel *phoneFisherExactTestLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneMidPExactLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone1TailedPLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone2TailedPLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneCorrectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneMantelHaenszelLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneUncorrectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneX2Label;
@property (weak, nonatomic) IBOutlet UILabel *phoneX2PLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneStatisticalTestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneRiskDifferenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneRelativeRiskLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneRiskEstimateLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneRiskLowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneRiskUpperLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneRiskBasedParametersLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneFisherExactCILabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneMLEORLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneOddsRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneOREstimateLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneORLowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneORUpperLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneOddsBasedParametersLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneOutcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneExposureLabel;
@property (weak, nonatomic) IBOutlet UITextField *yyField;
@property (weak, nonatomic) IBOutlet UITextField *ynField;
@property (weak, nonatomic) IBOutlet UITextField *nyField;
@property (weak, nonatomic) IBOutlet UITextField *nnField;
@property (weak, nonatomic) IBOutlet UILabel *orEstimate;
@property (weak, nonatomic) IBOutlet UILabel *orLower;
@property (weak, nonatomic) IBOutlet UILabel *orUpper;
@property (weak, nonatomic) IBOutlet UILabel *mleOR;
@property (weak, nonatomic) IBOutlet UILabel *mleLower;
@property (weak, nonatomic) IBOutlet UILabel *mleUpper;
@property (weak, nonatomic) IBOutlet UILabel *fisherLower;
@property (weak, nonatomic) IBOutlet UILabel *fisherUpper;
@property (weak, nonatomic) IBOutlet UILabel *rrEstimate;
@property (weak, nonatomic) IBOutlet UILabel *rrLower;
@property (weak, nonatomic) IBOutlet UILabel *rrUpper;
@property (weak, nonatomic) IBOutlet UILabel *rdEstimate;
@property (weak, nonatomic) IBOutlet UILabel *rdLower;
@property (weak, nonatomic) IBOutlet UILabel *rdUpper;
@property (weak, nonatomic) IBOutlet UILabel *uX2;
@property (weak, nonatomic) IBOutlet UILabel *uX2P;
@property (weak, nonatomic) IBOutlet UILabel *mhX2;
@property (weak, nonatomic) IBOutlet UILabel *mhX2P;
@property (weak, nonatomic) IBOutlet UILabel *cX2;
@property (weak, nonatomic) IBOutlet UILabel *cX2P;
@property (weak, nonatomic) IBOutlet UILabel *mpExact;
@property (weak, nonatomic) IBOutlet UILabel *fisherExact;
@property (weak, nonatomic) IBOutlet UILabel *fisherExact2;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *computingAdjustedOR;

@property (weak, nonatomic) IBOutlet UIButton *computeButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UILabel *oddsBasedParametersLabel;
@property (weak, nonatomic) IBOutlet UILabel *oddsRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *mleORLabel;
@property (weak, nonatomic) IBOutlet UILabel *riskBasedParametersLabel;
@property (weak, nonatomic) IBOutlet UILabel *riskBasedEstimateLabel;
@property (weak, nonatomic) IBOutlet UILabel *riskBasedEstimateLowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *riskBasedEstimateUpperLabel;
@property (weak, nonatomic) IBOutlet UILabel *relativeRiskLabel;
@property (weak, nonatomic) IBOutlet UILabel *statisticalTestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *x2Label;
@property (weak, nonatomic) IBOutlet UILabel *twoTailedPLabel;
@property (weak, nonatomic) IBOutlet UILabel *uncorrectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *mantelHaenszelLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctedLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneTailedPLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoTailedPForExactTestsLabel;
@property (weak, nonatomic) IBOutlet UILabel *midPExactLabel;
@property (weak, nonatomic) IBOutlet UILabel *fisherExactLabel;
@property (weak, nonatomic) IBOutlet UILabel *riskDifferenceLabel;

- (IBAction)compute:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)textFieldAction:(id)sender;
- (IBAction)resetBarButtonPressed:(id)sender;

//iPad
@property (weak,nonatomic) IBOutlet UIView *strataView;
@property (weak,nonatomic) IBOutlet UIView *summaryView;
@property (weak,nonatomic) IBOutlet UIView *ynView;

@property (weak, nonatomic) IBOutlet UILabel *crudeSEstimate;
@property (weak, nonatomic) IBOutlet UILabel *crudeSLower;
@property (weak, nonatomic) IBOutlet UILabel *crudeSUpper;
@property (weak, nonatomic) IBOutlet UILabel *crudeSmleOR;
@property (weak, nonatomic) IBOutlet UILabel *crudeSmleLower;
@property (weak, nonatomic) IBOutlet UILabel *crudeSmleUpper;
@property (weak, nonatomic) IBOutlet UILabel *fisherSLower;
@property (weak, nonatomic) IBOutlet UILabel *fisherSUpper;
@property (weak, nonatomic) IBOutlet UILabel *adjustedSEstimate;
@property (weak, nonatomic) IBOutlet UILabel *adjustedSLower;
@property (weak, nonatomic) IBOutlet UILabel *adjustedSUpper;
@property (weak, nonatomic) IBOutlet UILabel *adjustedSmleEstimate;
@property (weak, nonatomic) IBOutlet UILabel *adjustedSmleLower;
@property (weak, nonatomic) IBOutlet UILabel *adjustedSmleUpper;
@property (weak, nonatomic) IBOutlet UILabel *riskcrudeSEstimate;
@property (weak, nonatomic) IBOutlet UILabel *riskcrudeSLower;
@property (weak, nonatomic) IBOutlet UILabel *riskcrudeSUpper;
@property (weak, nonatomic) IBOutlet UILabel *riskadjSEstimate;
@property (weak, nonatomic) IBOutlet UILabel *riskadjcrudeSLower;
@property (weak, nonatomic) IBOutlet UILabel *riskadjSUpper;
@property (weak, nonatomic) IBOutlet UILabel *uSX2;
@property (weak, nonatomic) IBOutlet UILabel *uSX2P;
@property (weak, nonatomic) IBOutlet UILabel *mhSX2;
@property (weak, nonatomic) IBOutlet UILabel *mhSX2P;

@property (weak, nonatomic) IBOutlet UIScrollView *epiInfoScrollView0;
@property (weak, nonatomic) IBOutlet UINavigationBar *lowerNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *subView1;
@property (weak, nonatomic) IBOutlet UIView *subView2;
@property (weak, nonatomic) IBOutlet UIView *subView3;
@property (weak, nonatomic) IBOutlet UIView *subView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
//

@end
