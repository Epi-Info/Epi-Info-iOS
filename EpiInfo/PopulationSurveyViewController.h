//
//  PopulationSurveyViewController.h
//  EpiInfo
//
//  Created by John Copeland on 10/5/12.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ZoomView.h"
#import "ButtonRight.h"
#import "ButtonLeft.h"

@interface PopulationSurveyViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *customBackButton;
    
    BOOL currentOrientationPortrait;
    
    BOOL fourInchPhone;
    
    BOOL hasAFirstResponder;
    
    UITextField *sliderLabel1;
    UITextField *sliderLabel2;
    
    CGRect scrollViewFrame;
    UIImageView *fadingColorView;
    UIImageView *fadingColorView0;
    
    ZoomView *zoomingView;
    
    CGSize phonePortraitSize;
    CGSize phoneLandscapeSize;
    CGSize phoneLandscapeWithKeyboardSize;
    
    CGRect phoneInputsViewFrame;
    CGRect phoneInputsBlueBoxFrame;
    CGRect phoneInputsWhiteBoxFrame;
    CGRect phoneInputsWhiteBox2Frame;
    CGRect phoneMainLabelFrame;
    CGRect phoneSecondLabelFrame;
    CGRect phonePopulationSizeLabelFrame;
    CGRect phonePopulationSizeFieldFrame;
    CGRect phoneExpectedFrequencyLabelFrame;
    CGRect phoneExpectedFrequencyFieldFrame;
    CGRect phoneExpectedFrequencyPercentLabelFrame;
    CGRect phoneExpectedFrequencySliderFrame;
    CGRect phoneConfidenceLimitsLabelFrame;
    CGRect phoneConfidenceLimitsFieldFrame;
    CGRect phoneConfidenceLimitsPercentLabelFrame;
    CGRect phoneConfidenceLimitsSliderFrame;
    CGRect phoneDesignEffectLabelFrame;
    CGRect phoneDesignEffectFieldFrame;
    CGRect phoneClustersLabelFrame;
    CGRect phoneClustersFieldFrame;
    
    UIView *phoneInputsView;
    UIView *phoneInputsBlueBoxView;
    UIView *phoneInputsWhiteBoxView;
    UIView *phoneInputsWhiteBox2View;
    
    CGRect phoneResultsViewFrame;
    CGRect phoneResultsBlueBoxFrame;
    CGRect phoneConfidenceLevelLabelFrame;
    CGRect phoneClusterSizeLabelFrame;
    CGRect phoneTotalSampleLabelFrame;
    CGRect phone80PercentLabelFrame;
    CGRect phone90PercentLabelFrame;
    CGRect phone95PercentLabelFrame;
    CGRect phone97PercentLabelFrame;
    CGRect phone99PercentLabelFrame;
    CGRect phone999PercentLabelFrame;
    CGRect phone9999PercentLabelFrame;
    CGRect phoneClusterSize80Frame;
    CGRect phoneClusterSize90Frame;
    CGRect phoneClusterSize95Frame;
    CGRect phoneClusterSize97Frame;
    CGRect phoneClusterSize99Frame;
    CGRect phoneClusterSize999Frame;
    CGRect phoneClusterSize9999Frame;
    CGRect phoneTotalSample80Frame;
    CGRect phoneTotalSample90Frame;
    CGRect phoneTotalSample95Frame;
    CGRect phoneTotalSample97Frame;
    CGRect phoneTotalSample99Frame;
    CGRect phoneTotalSample999Frame;
    CGRect phoneTotalSample9999Frame;
    
    UIView *phoneResultsView;
    UIView *phoneResultsBlueBox;
    UIView *phoneWhiteBox0;
    UIView *phoneWhiteBox1;
    UIView *phoneWhiteBox2;
    UIView *phoneWhiteBox3;
    UIView *phoneWhiteBox4;
    UIView *phoneWhiteBox5;
    UIView *phoneWhiteBox6;
    UIView *phoneWhiteBox7;
    UIView *phoneWhiteBox8;
    UIView *phoneWhiteBox9;
    UIView *phoneWhiteBox10;
    UIView *phoneWhiteBox11;
    UIView *phoneWhiteBox12;
    UIView *phoneWhiteBox13;
    UIView *phoneWhiteBox14;
    UIView *phoneWhiteBox15;
    UIView *phoneWhiteBox16;
    UIView *phoneWhiteBox17;
    UIView *phoneWhiteBox18;
    UIView *phoneWhiteBox19;
    UIView *phoneWhiteBox20;
    UIView *phoneWhiteBox18a;
    UIView *phoneWhiteBox18b;
    UIView *phoneWhiteBox20a;
    UIView *phoneWhiteBox20b;
    
    ButtonLeft *blPhoneExpectedFrequency;
    ButtonRight *brPhoneExpectedFrequency;
    ButtonLeft *blPhoneConfidenceLimits;
    ButtonRight *brPhoneConfidenceLimits;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneExpectedFrequencyPercentLabel;
@property (weak, nonatomic) IBOutlet UISlider *phoneExpectedFrequencySlider;
@property (weak, nonatomic) IBOutlet UILabel *phoneConfidenceLimitsPercentLabel;
@property (weak, nonatomic) IBOutlet UISlider *phoneConfidenceLimitsSlider;
@property (weak, nonatomic) IBOutlet UILabel *phoneMainLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *phonePopulationSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneExpectedFrequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneConfidenceLimitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneDesignEffectsLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneClustersLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneConfidenceLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneClusterSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneTotalSampleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone80PercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone90PercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone95PercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone97PercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone99PercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone999PercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone9999PercentLabel;

@property (weak, nonatomic) IBOutlet UITextField *populationSizeField;
@property (weak, nonatomic) IBOutlet UITextField *expectedFrequencyField;
@property (weak, nonatomic) IBOutlet UITextField *confidenceLimitsField;
@property (weak, nonatomic) IBOutlet UITextField *designEffectField;
@property (weak, nonatomic) IBOutlet UITextField *clustersField;
@property (weak, nonatomic) IBOutlet UILabel *clusterSize80;
@property (weak, nonatomic) IBOutlet UILabel *totalSample80;
@property (weak, nonatomic) IBOutlet UILabel *clusterSize90;
@property (weak, nonatomic) IBOutlet UILabel *totalSample90;
@property (weak, nonatomic) IBOutlet UILabel *clusterSize95;
@property (weak, nonatomic) IBOutlet UILabel *totalSample95;
@property (weak, nonatomic) IBOutlet UILabel *clusterSize97;
@property (weak, nonatomic) IBOutlet UILabel *totalSample97;
@property (weak, nonatomic) IBOutlet UILabel *clusterSize99;
@property (weak, nonatomic) IBOutlet UILabel *totalSample99;
@property (weak, nonatomic) IBOutlet UILabel *clusterSize999;
@property (weak, nonatomic) IBOutlet UILabel *totalSample999;
@property (weak, nonatomic) IBOutlet UILabel *clusterSize9999;
@property (weak, nonatomic) IBOutlet UILabel *totalSample9999;

- (IBAction)compute:(id)sender;
- (IBAction)reset:(id)sender;

//iPad
@property (nonatomic,retain) IBOutlet UITextField *sliderLabel1;
@property (nonatomic,retain) IBOutlet UITextField *sliderLabel2;
@property (weak, nonatomic) IBOutlet UISlider *expectedFrequencySlider;
@property (weak, nonatomic) IBOutlet UIStepper *expectedFrequencyStepper;
@property (weak, nonatomic) IBOutlet UISlider *confidenceLimitsSlider;
@property (weak, nonatomic) IBOutlet UIStepper *confidenceLimitStepper;
@property (weak, nonatomic) IBOutlet UIScrollView *epiInfoScrollView0;
@property (weak, nonatomic) IBOutlet UINavigationBar *lowerNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *subView1;
@property (weak, nonatomic) IBOutlet UIView *subView2;

- (IBAction)textFieldBecameFirstResponder:(id)sender;

-(IBAction) sliderChanged1:(id) sender;
-(IBAction) sliderChanged2:(id) sender;
- (IBAction)stepperChanged1:(id)sender;
- (IBAction)stepperChanged2:(id)sender;
- (IBAction)textFieldAction:(id)sender;
- (IBAction)resetBarButtonPressed:(id)sender;
//
@end
